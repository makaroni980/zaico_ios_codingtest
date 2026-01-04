//
//  MockAlertPresenter.swift
//  zaico_ios_codingtest
//
//  Created by kazuki yoshida on 2026/01/02.
//

import UIKit
@testable import zaico_ios_codingtest

/**
 テスト用のアラート表示モック
 */
class MockAlertPresenter: AlertPresenterProtocol {
    var lastAlertTitle: String?
    var lastAlertMessage: String?
    var showAlertCallCount = 0
    
    func showAlert(on viewController: UIViewController, title: String, message: String) {
        showAlertCallCount += 1
        lastAlertTitle = title
        lastAlertMessage = message
    }
    
    /**
     モックの状態をリセットする
     */
    func reset() {
        lastAlertTitle = nil
        lastAlertMessage = nil
        showAlertCallCount = 0
    }
}
