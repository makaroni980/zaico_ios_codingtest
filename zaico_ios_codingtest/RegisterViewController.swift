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
    
    private let titleTextField = UITextField()
    private let registerButton = UIButton(type: .system)
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "在庫データ作成画面"
        view.backgroundColor = .white
        
        setupTitleTextField()
        setupRegisterButton()
        setupTableView()
    }
    
    private func setupTitleTextField() {
        titleTextField.placeholder = "タイトルを入力"
        titleTextField.borderStyle = .roundedRect
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleTextField)
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupRegisterButton() {
        registerButton.setTitle("登録", for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 8
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
    
    @objc private func registerButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
//            showAlert(message: "タイトルを入力してください")
            return
        }
        
        Task {
            await createData(title: title)
        }
    }
    
    @MainActor
    private func createData(title: String) async {
        registerButton.isEnabled = false
        registerButton.setTitle("登録中...", for: .normal)
        
        defer {
            registerButton.isEnabled = true
            registerButton.setTitle("登録", for: .normal)
        }
        
        do {
            _ = try await APIClient.shared.createInventory(title: title)
            titleTextField.text = ""
        } catch {
//            showAlert(message: "登録に失敗しました: \(error.localizedDescription)")
        }
    }
}
