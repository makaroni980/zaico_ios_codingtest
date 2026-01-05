//
//  AlertPresenter.swift
//  zaico_ios_codingtest
//
//  Created by kazuki yoshida on 2026/01/02.
//

import UIKit

/**
 アラートプレゼンタープロトコル
 */
protocol AlertPresenterProtocol {
    func showAlert(on viewController: UIViewController, title: String, message: String)
}

/**
 アラートプレゼンター
 */
class AlertPresenter: AlertPresenterProtocol {
    func showAlert(on viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        viewController.present(alert, animated: false)
    }
}
