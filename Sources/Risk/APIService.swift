//
//  APIService.swift
//  Risk
//  Sources
//
//  Created by Precious Ossai on 30/10/2023.
//

import Foundation

protocol APIServiceProtocol {
    func getJSONFromAPIWithAuthorization<T: Decodable>(endpoint: String, authToken: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void)
    func putDataToAPIWithAuthorization<T: Encodable, U: Decodable>(endpoint: String, authToken: String, data: T, responseType: U.Type, completion: @escaping (Result<U, Error>) -> Void)
}

enum APIServiceError: Error {
    case invalidURL
    case noData
    case httpError(Int)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No Data"
        case .httpError(let code):
            return "HTTP Error: \(code)"
        }
    }
}

struct APIService: APIServiceProtocol {
    
    func getJSONFromAPIWithAuthorization<T: Decodable>(endpoint: String, authToken: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(APIServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.setValue(authToken, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIServiceError.httpError((response as? HTTPURLResponse)?.statusCode ?? 500)))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIServiceError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    public func putDataToAPIWithAuthorization<T: Encodable, U: Decodable>(endpoint: String, authToken: String, data: T, responseType: U.Type, completion: @escaping (Result<U, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(APIServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        request.setValue(authToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            encoder.outputFormatting = .prettyPrinted
            
            let jsonData = try encoder.encode(data)
            
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIServiceError.httpError((response as? HTTPURLResponse)?.statusCode ?? 500)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if let data = data {
                    let decodedData = try decoder.decode(U.self, from: data)
                    completion(.success(decodedData))
                } else {
                    completion(.failure(APIServiceError.noData))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
}
