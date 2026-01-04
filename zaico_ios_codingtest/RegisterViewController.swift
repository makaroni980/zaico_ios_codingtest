//
//  RegisterViewController.swift
//  zaico_ios_codingtest
//
//  Created by kazuki yoshida on 2025/12/24.
//

import UIKit

/**
 在庫データ作成画面
 */
class RegisterViewController : UIViewController, UITableViewDelegate {
    
    private let titleLabel = UILabel()
    private let titleTextField = UITextField()
    private let registerButton = UIButton(type: .system)
    private let tableView = UITableView()
    
    // 依存性注入用のプロパティ
    private let apiClient: APIClientProtocol
    private let alertPresenter: AlertPresenterProtocol
    
    /**
     イニシャライザ
     
     - parameter apiClient: APIクライアント
     - parameter alertPresenter: アラート表示
     */
    init(apiClient: APIClientProtocol = APIClient.shared,
         alertPresenter: AlertPresenterProtocol = AlertPresenter()) {
        self.apiClient = apiClient
        self.alertPresenter = alertPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.apiClient = APIClient.shared
        self.alertPresenter = AlertPresenter()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "在庫データ作成画面"
        view.backgroundColor = .white
        
        // ビューのセットアップ
        setupTitleLabel()
        setupTitleTextField()
        setupRegisterButton()
        setupTableView()
    }
    
    /**
     タイトルラベルをセットアップする。
     */
    private func setupTitleLabel() {
        titleLabel.text = "在庫名"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.accessibilityIdentifier = "titleLabel"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    /**
     タイトルテキストフィールドをセットアップする。
     */
    private func setupTitleTextField() {
        titleTextField.placeholder = "在庫名を入力"
        titleTextField.borderStyle = .roundedRect
        titleTextField.accessibilityIdentifier = "titleTextField"
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleTextField)
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    /**
     登録ボタンをセットアップする。
     */
    private func setupRegisterButton() {
        registerButton.setTitle("登録", for: .normal)
        registerButton.backgroundColor = .black
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 8
        registerButton.accessibilityIdentifier = "registerButton"
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        view.addSubview(registerButton)
        NSLayoutConstraint.activate([
            registerButton.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            registerButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    /**
     テーブルビューをセットアップする。
     */
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    /**
     登録ボタンがタップされた際に呼ばれる。
     タイトルテキストフィールドに在庫名が入力されていればデータ生成処理を実行する。
     在庫名が入力されていなければ、未入力エラーを表示する。
     */
    @objc private func registerButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(title: "未入力エラー", message: "在庫名を入力してください")
            return
        }
        
        Task {
            await createData(title: title)
        }
    }
    
    /**
     在庫データを生成する。
     引数で渡された文字列を元に在庫データを生成する。
     
     - parameter title: 在庫名
     */
    @MainActor
    private func createData(title: String) async {
        // 登録ボタンを非活性にし、文言を変更する。
        registerButton.isEnabled = false
        registerButton.setTitle("登録中...", for: .normal)
        
        // スコープを抜ける際に、元々の登録ボタンの文言に変更する。
        defer {
            registerButton.isEnabled = true
            registerButton.setTitle("登録", for: .normal)
        }
        
        do {
            _ = try await apiClient.createInventory(title: title)
            showAlert(title: "登録に成功しました", message: "")
            // テキストフィールドに入力されている文言を空文字に変更する。
            titleTextField.text = ""
        } catch {
            showAlert(title: "登録に失敗しました", message: "\(error.localizedDescription)")
        }
    }
    
    /**
     アラートを表示する。
     
     - parameter title: タイトル
     - parameter message: メッセージ
     */
    private func showAlert(title: String, message: String) {
        alertPresenter.showAlert(on: self, title: title, message: message)
    }
}
