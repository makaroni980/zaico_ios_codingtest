//
//  APIClientProtocol.swift
//  zaico_ios_codingtest
//
//  Created by kazuki yoshida on 2025/12/29.
//

import Foundation

/**
 APIクライアントのプロトコル
 テスト時にモック実装を注入できるようにする
 */
protocol APIClientProtocol {
    func fetchInventories() async throws -> [Inventory]
    
    func fetchInventorie(id: Int?) async throws -> Inventory
    
    func createInventory(title: String) async throws -> APIClient.APIResponse
}
