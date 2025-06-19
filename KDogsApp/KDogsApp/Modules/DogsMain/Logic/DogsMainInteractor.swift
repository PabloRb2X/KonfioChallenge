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
    func saveDogsToCoreData(_ dogs: [DogModel])
    func fetchDogsFromCoreData() -> [DogModel]
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
    
    func saveDogsToCoreData(_ dogs: [DogModel]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        emptyDogsData(context: context)
        
        for dog in dogs {
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        let context = appDelegate.persistentContainer.viewContext
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
    func emptyDogsData(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = DogEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            // Not implemented
        }
    }
}
