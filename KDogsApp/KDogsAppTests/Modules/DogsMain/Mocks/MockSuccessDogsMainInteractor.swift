//
//  MockSuccessDogsMainInteractor.swift
//  KDogsAppTests
//
//  Created by Pablo Ramirez on 19/06/25.
//

import Foundation
import Combine
import Alamofire
@testable import KDogsApp

final class MockSuccessDogsMainInteractor: DogsMainInteractorProtocol {
    var dogsList: [DogModel] = []
    var savedDogs: [DogModel] = []
    var didCallFetchFromCoreData = false
    
    func fetchDogsList() -> AnyPublisher<[DogModel], AFError> {
        let mockDogs = [
            DogModel(dogName: "dog_name", description: "dog_description", age: 5, image: "dog.jpg")
        ]
        
        return Just(mockDogs)
            .setFailureType(to: AFError.self)
            .eraseToAnyPublisher()
    }
    
    func saveDogsToCoreData() {
        savedDogs = dogsList
    }
    
    func fetchDogsFromCoreData() -> [DogModel] {
        didCallFetchFromCoreData = true
        
        return []
    }
}
