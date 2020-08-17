//
//  NetworkService.swift
//  todo
//
//  Created by hax0r-MBP on 8/16/19.
//  Copyright © 2019 Devslopes. All rights reserved.
//

import Foundation


class NetworkService {
    static let shared = NetworkService()
    
    let URL_BASE = "http://localhost:3003"
    let URL_ADD_TODO = "/add"
    
    let session = URLSession(configuration: .default)
    
    func getTodos(onSuccess: @escaping (Todos) -> Void, onError: @escaping (String) -> Void) {
        let url = URL(string: "\(URL_BASE)")!
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }
                
                do {
                    if response.statusCode == 200 {
                        let items = try JSONDecoder().decode(Todos.self, from: data)
                        onSuccess(items)
                    } else {
                        let err = try JSONDecoder().decode(APIError.self, from: data)
                        onError(err.message)
                    }
                }
                catch {
                    onError(error.localizedDescription)
                }
            }
            
        }
        task.resume()
    }
    
    func addTodo(todo: Todo, onSuccess: @escaping (Todos) -> Void, onError: @escaping (String) -> Void) {
        let url = URL(string: "\(URL_BASE)\(URL_ADD_TODO)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let body = try JSONEncoder().encode(todo)
            request.httpBody = body
            
            let task = session.dataTask(with: request) { (data, response, error) in
                
                DispatchQueue.main.async {
                    if let error = error {
                        onError(error.localizedDescription)
                        return
                    }
                    
                    guard let data = data, let response = response as? HTTPURLResponse else {
                        onError("Invalid data or response")
                        return
                    }
                    
                    do {
                        if response.statusCode == 200 {
                            let items = try JSONDecoder().decode(Todos.self, from: data)
                            onSuccess(items)
                        } else {
                            let err = try JSONDecoder().decode(APIError.self, from: data)
                            onError(err.message)
                        }
                    } catch {
                        onError(error.localizedDescription)
                    }
                }
                
                
            }
            task.resume()
            
        } catch {
            onError(error.localizedDescription)
        }
        
    }
}
