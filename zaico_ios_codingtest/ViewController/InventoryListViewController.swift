//
//  InventoryListViewController.swift
//  zaico_ios_codingtest
//
//  Created by ryo hirota on 2025/03/11.
//

import UIKit

/**
 在庫リストビューコントローラー
 */
class InventoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private var inventories: [Inventory] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "在庫一覧"
        
        setupTableView()
        setupRegisterButton()
        
        Task {
            await fetchData()
        }
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.register(InventoryCell.self, forCellReuseIdentifier: "InventoryCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    /**
     登録ボタンのセットアップ
     */
    private func setupRegisterButton(){
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        button.frame = CGRect(x: self.view.frame.size.width - 76, y: self.view.frame.size.height - 150, width: 60  , height: 60)
        self.view.addSubview(button)
    }
    
    /**
     登録ボタンがタップされた際に呼ばれる。
     在庫データ作成画面に遷移する。
     */
    @objc func registerButtonTapped() {
        let registerVC = InventoryRegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    private func fetchData() async {
        do {
            let data = try await APIClient.shared.fetchInventories()
            await MainActor.run {
                inventories = data
                tableView.reloadData()
            }
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
        cell.configure(leftText: String(inventories[indexPath.row].id),
                       rightText: inventories[indexPath.row].title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = InventoryDetailViewController(id: inventories[indexPath.row].id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
