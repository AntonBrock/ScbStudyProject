//
//  NetworkService.swift
//  Project Y
//
//  Created by Admin on 10.09.2020.
//  Copyright © 2020 Anton Dobrynin. All rights reserved.
//

import Foundation

class NetworkService {
    
    func request(completion: @escaping (Data?, Error?) -> Void) {
        let paraments = self.prepareParaments(count: 10)
        let url = self.url(params: paraments)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeaders()
        request.httpMethod = "get"
        
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareHeaders() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID y2J3uFzWSeAlfA6B8w2UVa2u6XlMeUQC2O3h5hTU4v4"
        return headers
    }
    
    private func prepareParaments(count: Int) -> [String: String] {
        var params = [String: String]()
        params["count"] = String(count)
        return params
    }

    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos/random"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        return components.url!
        
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
