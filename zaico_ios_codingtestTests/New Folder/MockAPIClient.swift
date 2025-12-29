//
//  MockAPIClient.swift
//  zaico_ios_codingtest
//
//  Created by kazuki yoshida on 2025/12/29.
//

import Foundation
@testable import zaico_ios_codingtest

/**
 テスト用のAPIクライアントモック
 */
class MockAPIClient: APIClientProtocol {
    
    // テスト用の設定
    var shouldSucceed = true
    var errorToThrow: Error?
    var responseToReturn: APIClient.APIResponse?
    
    // 呼び出し確認用
    var createInventoryCallCount = 0
    var lastCalledTitle: String?
    
    func fetchInventories() async throws -> [Inventory] {
        // TODO: 今後のテストで使用する際に実装を追加
        return []
    }
    
    // MARK: - fetchInventorie (未使用、定数を返す)
    
    func fetchInventorie(id: Int?) async throws -> Inventory {
        // TODO: 今後のテストで使用する際に実装を追加
        return Inventory(
            id: 1,
            title: "サンプル在庫",
            quantity: "10",
            itemImage: ItemImage(url: nil)
        )
    }
    
    func createInventory(title: String) async throws -> APIClient.APIResponse {
        createInventoryCallCount += 1
        lastCalledTitle = title
        
        // エラーを投げる設定の場合
        if let error = errorToThrow {
            throw error
        }
        
        // 失敗する設定の場合
        if !shouldSucceed {
            throw URLError(.badServerResponse)
        }
        
        // カスタムレスポンスが設定されている場合
        if let response = responseToReturn {
            return response
        }
        
        // デフォルトの成功レスポンス
        return APIClient.APIResponse(
            code: 200,
            status: "success",
            message: "在庫を作成しました"
        )
    }
    
    /**
     モックの状態をリセットする
     */
    func reset() {
        shouldSucceed = true
        errorToThrow = nil
        responseToReturn = nil
        createInventoryCallCount = 0
        lastCalledTitle = nil
    }
}
