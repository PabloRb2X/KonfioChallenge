//
//  DogsMainInteractor.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import Combine
import Alamofire

protocol DogsMainInteractorProtocol {
    var dogsList: [DogModel] { get set }
    
    func fetchDogsList() -> AnyPublisher<[DogModel], AFError>
}

final class DogsMainInteractor {
    private let networkManager: AppNetworkManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    var dogsList: [DogModel] = []
    
    init(networkManager: AppNetworkManagerProtocol = AppNetworkManager()) {
        self.networkManager = networkManager
    }
}

extension DogsMainInteractor: DogsMainInteractorProtocol {
    func fetchDogsList() -> AnyPublisher<[DogModel], AFError> {
        networkManager.fetch(APIRouter.fetchDogsList, decoder: .init())
    }
}
