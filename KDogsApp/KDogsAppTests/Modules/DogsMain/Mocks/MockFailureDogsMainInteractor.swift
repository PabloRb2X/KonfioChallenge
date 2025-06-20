//
//  MockDogsMainInteractor.swift
//  KDogsAppTests
//
//  Created by Pablo Ramirez on 19/06/25.
//

import Foundation
import Combine
import Alamofire
@testable import KDogsApp

final class MockFailureDogsMainInteractor: DogsMainInteractorProtocol {
    var savedDogs: [DogModel] = []
    var dogsList: [DogModel] = []
    
    func fetchDogsList() -> AnyPublisher<[DogModel], AFError> {
        return Fail(error: AFError.explicitlyCancelled).eraseToAnyPublisher()
    }

    func saveDogsToCoreData() {
        savedDogs = dogsList
    }

    func fetchDogsFromCoreData() -> [DogModel] {
        return [
            DogModel(dogName: "dog_name", description: "dog_description", age: 5, image: "dog.jpg")
        ]
    }
}
