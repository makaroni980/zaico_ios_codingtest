//
//  RegisterViewControllerTests.swift
//
//  Created by kazuki yoshida on 2025/12/29.
//

import Testing
import UIKit
@testable import zaico_ios_codingtest

/**
 RegisterViewControllerのテスト
 */
@Suite("RegisterViewController Tests")
struct RegisterViewControllerTests {
    
    // MARK: - Setup Helper
    
    /**
     テスト用のViewControllerとモックを作成する
     ウィンドウも返してテスト中に保持できるようにする
     */
    @MainActor
    func makeViewController() -> (RegisterViewController, MockAPIClient, MockAlertPresenter, UIWindow) {
        let mockAPIClient = MockAPIClient()
        let mockAlertPresenter = MockAlertPresenter()
        let viewController = RegisterViewController(apiClient: mockAPIClient, alertPresenter: mockAlertPresenter)
        
        // アラート表示のため、ViewControllerをウィンドウ階層に追加
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        // ViewDidLoadを呼び出すためにビューを読み込む
        viewController.loadViewIfNeeded()
        
        // ビュー階層を強制的に更新
        window.layoutIfNeeded()
        
        return (viewController, mockAPIClient, mockAlertPresenter, window)
    }
    
    
    
    // MARK: - 初期表示のテスト
    
    @Test("ViewControllerのタイトルが正しく設定されている")
    @MainActor
    func testViewControllerTitle() async throws {
        let (viewController, _, _, _) = makeViewController()
        
        #expect(viewController.title == "在庫データ作成画面")
    }
    
    @Test("背景色が白色に設定されている")
    @MainActor
    func testBackgroundColor() async throws {
        let (viewController, _, _, _) = makeViewController()
        
        #expect(viewController.view.backgroundColor == .white)
    }
    
    @Test("在庫名タイトルラベルが正しく配置されている")
    @MainActor
    func testTitleLabelSetup() async throws {
        let (viewController, _, _, _) = makeViewController()
        
        let titleLabel = getLabel(from: viewController, identifier: "titleLabel")
        
        #expect(titleLabel != nil)
        #expect(titleLabel?.text == "在庫名")
        #expect(titleLabel?.font == .systemFont(ofSize: 16, weight: .medium))
    }
    
    @Test("タイトルテキストフィールドが正しく配置されている")
    @MainActor
    func testTitleTextFieldSetup() async throws {
        let (viewController, _, _, _) = makeViewController()
        
        let textField = getTextField(from: viewController, identifier: "titleTextField")
        
        #expect(textField != nil)
        #expect(textField?.placeholder == "在庫名を入力")
        #expect(textField?.borderStyle == .roundedRect)
    }
    
    @Test("登録ボタンが正しく配置されている")
    @MainActor
    func testRegisterButtonSetup() async throws {
        let (viewController, _, _, _) = makeViewController()
        
        let button = getButton(from: viewController, identifier: "registerButton")
        
        #expect(button != nil)
        #expect(button?.title(for: .normal) == "登録")
        #expect(button?.backgroundColor == .black)
        #expect(button?.titleColor(for: .normal) == .white)
    }
    
    // MARK: - 入力バリデーションのテスト
    
    @Test("空文字で登録ボタンをタップすると未入力エラーアラートが表示される")
    @MainActor
    func testRegisterWithEmptyTitle() async throws {
        let (viewController, mockAPIClient, mockAlertPresenter, _) = makeViewController()
        
        let textField = getTextField(from: viewController, identifier: "titleTextField")
        let button = getButton(from: viewController, identifier: "registerButton")
        
        // テキストフィールドを空にする。
        textField?.text = ""
        
        // 登録ボタンをタップする。
        button?.sendActions(for: .touchUpInside)
        
        // 同期的に実行されるためyieldを実行。
        await Task.yield()
        
        // 在庫データ作成のAPIが呼ばれていないこと。
        #expect(mockAPIClient.createInventoryCallCount == 0)
        
        // 在庫名が未入力であることを伝えるアラートが表示されていること。
        #expect(mockAlertPresenter.lastAlertTitle == "未入力エラー")
        #expect(mockAlertPresenter.lastAlertMessage == "在庫名を入力してください")
    }
    
    @Test("在庫名テキストフィールドがnilの状態で登録ボタンをタップすると未入力エラーアラートが表示される")
    @MainActor
    func testRegisterWithNilTitle() async throws {
        let (viewController, mockAPIClient, mockAlertPresenter, _) = makeViewController()
        
        let textField = getTextField(from: viewController, identifier: "titleTextField")
        let button = getButton(from: viewController, identifier: "registerButton")
        
        // テキストフィールドをnilにする
        textField?.text = nil
        
        // 登録ボタンをタップする。
        button?.sendActions(for: .touchUpInside)
        
        // 同期的に実行されるためyieldを実行。
        await Task.yield()
        
        // 在庫データ作成のAPIが呼ばれていないこと。
        #expect(mockAPIClient.createInventoryCallCount == 0)
        
        // 在庫名が未入力であることを伝えるアラートが表示されていること。
        #expect(mockAlertPresenter.lastAlertTitle == "未入力エラー")
        #expect(mockAlertPresenter.lastAlertMessage == "在庫名を入力してください")
    }
    
    // MARK: - API呼び出し成功のテスト
    
    @Test("在庫名テキストフィールドに在名を入力している状態で登録ボタンをタップすると在庫データの登録が成功する")
    @MainActor
    func testSuccessfulRegistration() async throws {
        let (viewController, mockAPIClient, mockAlertPresenter, _) = makeViewController()
        
        let textField = getTextField(from: viewController, identifier: "titleTextField")
        let button = getButton(from: viewController, identifier: "registerButton")
        
        // テスト用の在庫名を入力する。
        let testTitle = "テスト在庫"
        textField?.text = testTitle
        
        // モックを成功する設定にする。
        mockAPIClient.shouldSucceed = true
        
        // 登録ボタンをタップする。
        button?.sendActions(for: .touchUpInside)
        
        // Task内の非同期処理完了を待つ。
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // 在庫データ作成APIが正しいパラメータで呼ばれていること。
        #expect(mockAPIClient.createInventoryCallCount == 1)
        #expect(mockAPIClient.lastCalledTitle == testTitle)
        
        // 登録に成功した旨を伝えるアラートが表示されていること。
        #expect(mockAlertPresenter.lastAlertTitle == "登録に成功しました")
        #expect(mockAlertPresenter.lastAlertMessage == "")
        
        // テキストフィールドがクリアされていること。
        #expect(textField?.text == "")
    }
    
    // MARK: - API呼び出し失敗のテスト
    
    @Test("在庫登録失敗時にエラーアラートが表示される")
    @MainActor
    func testFailedRegistration() async throws {
        let (viewController, mockAPIClient, mockAlertPresenter, _) = makeViewController()
        
        let textField = getTextField(from: viewController, identifier: "titleTextField")
        let button = getButton(from: viewController, identifier: "registerButton")
        
        textField?.text = "テスト在庫"
        
        // モックを失敗する設定にする。
        mockAPIClient.shouldSucceed = false
        
        // 登録ボタンをタップする。
        button?.sendActions(for: .touchUpInside)
        
        // Task内の非同期処理完了を待つ。
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // 在庫データ作成APIが呼ばれていること。
        #expect(mockAPIClient.createInventoryCallCount == 1)
        
        // 登録に失敗した旨を伝えるアラート情報が記録されていること。
        #expect(mockAlertPresenter.lastAlertTitle == "登録に失敗しました")
        #expect(mockAlertPresenter.lastAlertMessage != nil)
        
        // 在庫名テキストフィールドはクリアされていないこと。
        #expect(textField?.text == "テスト在庫")
    }
    
    // MARK: - 複数回の操作テスト
    
    @Test("連続して登録操作を行える")
    @MainActor
    func testMultipleRegistrations() async throws {
        let (viewController, mockAPIClient, _, _) = makeViewController()
        
        let textField = getTextField(from: viewController, identifier: "titleTextField")
        let button = getButton(from: viewController, identifier: "registerButton")
        
        // 1回目の登録
        textField?.text = "在庫1"
        button?.sendActions(for: .touchUpInside)
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // 2回目の登録
        textField?.text = "在庫2"
        button?.sendActions(for: .touchUpInside)
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // APIが2回呼ばれていること。
        #expect(mockAPIClient.createInventoryCallCount == 2)
        #expect(mockAPIClient.lastCalledTitle == "在庫2")
    }
    
    // MARK: - UI要素取得ヘルパー
    
    /**
     ViewControllerから指定されたaccessibilityIdentifierを持つUILabelを取得する
     
     - parameter viewController: 対象のViewController
     - parameter identifier: accessibilityIdentifier
     - returns: 見つかったUILabel、見つからない場合はnil
     */
    @MainActor
    private func getLabel(from viewController: UIViewController, identifier: String) -> UILabel? {
        return viewController.view.subviews.first { view in
            view.accessibilityIdentifier == identifier
        } as? UILabel
    }
    
    /**
     ViewControllerから指定されたaccessibilityIdentifierを持つUITextFieldを取得する
     
     - parameter viewController: 対象のViewController
     - parameter identifier: accessibilityIdentifier
     - returns: 見つかったUITextField、見つからない場合はnil
     */
    @MainActor
    private func getTextField(from viewController: UIViewController, identifier: String) -> UITextField? {
        return viewController.view.subviews.first { view in
            view.accessibilityIdentifier == identifier
        } as? UITextField
    }
    
    /**
     ViewControllerから指定されたaccessibilityIdentifierを持つUIButtonを取得する
     
     - parameter viewController: 対象のViewController
     - parameter identifier: accessibilityIdentifier
     - returns: 見つかったUIButton、見つからない場合はnil
     */
    @MainActor
    private func getButton(from viewController: UIViewController, identifier: String) -> UIButton? {
        return viewController.view.subviews.first { view in
            view.accessibilityIdentifier == identifier
        } as? UIButton
    }
}
