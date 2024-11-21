//
//  NetworkManager.swift
//  ToDo
//
//  Created by PinkXaciD on 2024/11/19.
//

import Foundation

final class NetworkManager {
    private let urlSession = URLSession(configuration: .default)
    
    static let shared = NetworkManager()
    
    func getData(_ completionHandler: @escaping ([ToDoEntity]) async -> Void) async {
        var request = URLRequest(url: .toDoApi)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        do {
            let data = try await urlSession.data(for: request)
            
            guard let response = data.1 as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            
            let decoder = JSONDecoder()
            decoder.userInfo[.moc] = DataManager.shared.context
            
            let result = try decoder.decode(DownloadedToDos.self, from: data.0)
            await completionHandler(result.todos)
        } catch {
            print(error)
        }
        
        return
    }
}

struct DownloadedToDos: Codable {
    let todos: [ToDoEntity]
    let total: Int
    let skip: Int
    let limit: Int
}
