//
//  APIClient.swift
//  zaico_ios_codingtest
//
//  Created by ryo hirota on 2025/03/11.
//

import Foundation

class APIClient: APIClientProtocol {
    static let shared = APIClient()
    
    private let baseURL = "https://web.zaico.co.jp"
    private let token = "pw9NHWQn8UxUXcipHvM7xd1XoGKH4egf"
    
    private init() {}

    func fetchInventories() async throws -> [Inventory] {
        let endpoint = "/api/v1/inventories"
        
        guard let url = URL(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    throw URLError(.badServerResponse)
                }
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("[APIClient] API Response: \(jsonString)")
            }
            
            return try JSONDecoder().decode([Inventory].self, from: data)
        } catch {
            throw error
        }
    }
    
    func fetchInventorie(id: Int?) async throws -> Inventory {
        var endpoint = "/api/v1/inventories"
        
        if let id = id {
            endpoint += "/\(id)"
        }
        
        guard let url = URL(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    throw URLError(.badServerResponse)
                }
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("[APIClient] API Response: \(jsonString)")
            }
            
            return try JSONDecoder().decode(Inventory.self, from: data)
        } catch {
            throw error
        }
    }
    
    /**
     在庫データを作成する。
     
     - parameter title: 在庫タイトル
     */
    func createInventory(title: String) async throws -> CreateInventoryAPIResponse {
        let endpoint = "/api/v1/inventories"
        
        guard let url = URL(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // リクエストボディを作成
        let requestBody = CreateInventoryAPIRequestBody(title: title)
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    throw URLError(.badServerResponse)
                }
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("[APIClient] API Response: \(jsonString)")
            }
            
            let apiResponse = try JSONDecoder().decode(CreateInventoryAPIResponse.self, from: data)
            return apiResponse
        } catch {
            throw error
        }
    }
    
    /**
     在庫データ作成APIのリクエストボディ
     */
    struct CreateInventoryAPIRequestBody: Codable {
        let title: String
    }
    
    /**
     在庫データ作成APIのレスポンス
     */
    struct CreateInventoryAPIResponse: Codable {
        let code: Int
        let status: String
        let message: String
    }
}

