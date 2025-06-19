//
//  AppNetworkManager.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import Foundation
import Combine
import Alamofire

protocol AppNetworkManagerProtocol: AnyObject {
    func fetch<T: Decodable>(
        _ request: URLRequestConvertible,
        decoder: JSONDecoder
    ) -> AnyPublisher<T, AFError>
}

final class AppNetworkManager: AppNetworkManagerProtocol {
    init() {}
    
    func fetch<T: Decodable>(
        _ request: URLRequestConvertible,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<T, AFError> {
        
        let future = Future<T, AFError> { promise in
            AF.request(request).responseDecodable(of: T.self) { response in
                if let value = response.value {
                    promise(.success(value))
                } else if let error = response.error {
                    promise(.failure(error))
                }
            }
        }
        
        return future.eraseToAnyPublisher()
    }
}
