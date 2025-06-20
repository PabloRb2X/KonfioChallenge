//
//  DogsMainInteractor.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import Combine
import Alamofire
import UIKit
import CoreData

protocol DogsMainInteractorProtocol {
    var dogsList: [DogModel] { get set }
    
    func fetchDogsList() -> AnyPublisher<[DogModel], AFError>
    func saveDogsToCoreData()
    func fetchDogsFromCoreData() -> [DogModel]
}

final class DogsMainInteractor {
    private let networkManager: AppNetworkManagerProtocol
    private var coreDataContext: NSManagedObjectContext?
    private var cancellables = Set<AnyCancellable>()
    
    var dogsList: [DogModel] = []
    
    init(
        coreDataContext: NSManagedObjectContext? = nil,
        networkManager: AppNetworkManagerProtocol = AppNetworkManager()
    ) {
        self.coreDataContext = coreDataContext
        self.networkManager = networkManager
    }
}

extension DogsMainInteractor: DogsMainInteractorProtocol {
    func fetchDogsList() -> AnyPublisher<[DogModel], AFError> {
        networkManager.fetch(APIRouter.fetchDogsList, decoder: .init())
    }
    
    func saveDogsToCoreData() {
        guard let context = coreDataContext else { return }
        
        emptyDogsData()
        
        for dog in dogsList {
            let entity = DogEntity(context: context)
            
            entity.dogName = dog.dogName
            entity.descrip = dog.description
            entity.age = Int32(dog.age)
            entity.image = dog.image
        }

        do {
            try context.save()
        } catch {
            // Not implemented
        }
    }
    
    func fetchDogsFromCoreData() -> [DogModel] {
        guard let context = coreDataContext else { return [] }
        
        let request: NSFetchRequest<DogEntity> = DogEntity.fetchRequest()

        do {
            let results = try context.fetch(request)
            
            return results.map { entity in
                DogModel(
                    dogName: entity.dogName,
                    description: entity.descrip,
                    age: Int(entity.age),
                    image: entity.image
                )
            }
        } catch {
            return []
        }
    }
}

private extension DogsMainInteractor {
    func emptyDogsData() {
        guard let context = coreDataContext else { return }

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = DogEntity.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            results?.forEach { context.delete($0) }
        } catch {
            // Not implemented
        }
    }
}
