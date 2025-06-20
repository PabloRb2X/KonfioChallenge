//
//  MockNetworkManagerSuccess.swift
//  KDogsAppTests
//
//  Created by Pablo Ramirez on 19/06/25.
//

import Foundation
import Alamofire
import Combine
@testable import KDogsApp

final class MockNetworkManagerSuccess: AppNetworkManagerProtocol {
    
    func fetch<T>(_ request: URLRequestConvertible, decoder: JSONDecoder = .init()) -> AnyPublisher<T, AFError> where T: Decodable {
        let mockData: [DogModel] = [
            DogModel(dogName: "dog_name", description: "dog_description", age: 5, image: "dog.jpg")
        ]
        
        return Just(mockData as! T)
            .setFailureType(to: AFError.self)
            .eraseToAnyPublisher()
    }
}
