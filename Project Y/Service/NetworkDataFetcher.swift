//
//  NetworkDataFetching.swift
//  Project Y
//
//  Created by Admin on 10.09.2020.
//  Copyright © 2020 Anton Dobrynin. All rights reserved.
//

import Foundation

class NetworkDataFetcher {
    var networkService = NetworkService()
    
    func fetchImages(completion: @escaping ([ImagesResults]?) -> ()) {
        networkService.request() { (data, error) in
            if let error = error {
                print("Error with request: \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: [ImagesResults].self, from: data)
            completion(decode)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        
        guard let safeData = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: safeData)
            return objects
        } catch let jsonError {
            print("Error with parseJSON", jsonError)
            return nil
        }
    }

    
    
// не знаю, почему не сработало это. Нашел в инете через генерик для любого типа
//    func parseJSON(forType: Decodable?, fromData: Data?) {
//        let decoder = JSONDecoder()
//
//        guard let safeData = fromData else { return }
//        do {
//            let objects = try decoder.decode(forType.self, from: safeData)
//        } catch let jsonError {
//            print("Error with parseJSON", jsonError)
//            return
//        }
//    }
}
