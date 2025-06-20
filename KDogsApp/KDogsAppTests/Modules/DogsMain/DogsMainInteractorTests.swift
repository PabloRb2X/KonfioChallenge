//
//  DogsMainInteractorTests.swift
//  KDogsAppTests
//
//  Created by Pablo Ramirez on 19/06/25.
//

import XCTest
import CoreData
import Combine
import Alamofire

@testable import KDogsApp

final class DogsMainInteractorTests: XCTestCase {
    
    private var sut: DogsMainInteractor?
    private let mockNetwork = MockNetworkManagerSuccess()
    private var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
    }
    
    func test_fetchDogsList_shouldReturnExpectedData() {
        // GIVEN
        
        sut = DogsMainInteractor(coreDataContext: makeInMemoryContext(), networkManager: mockNetwork)
        
        let expectation = expectation(description: "fetchDogsList")
        var received: [DogModel] = []
        
        // WHEN
        
        sut?.fetchDogsList()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { value in
                received = value
                expectation.fulfill()
            })
            .store(in: &subscriptions)
        
        // THEN
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(received.count, 1)
        XCTAssertEqual(received.first?.dogName, "dog_name")
    }
    
    func test_saveAndFetchDogs_shouldPersistToCoreData() {
        // GIVEN
        
        sut = DogsMainInteractor(coreDataContext: makeInMemoryContext(), networkManager: mockNetwork)
        
        // WHEN
        
        let dog = DogModel(dogName: "dog_name", description: "dog_description", age: 5, image: "dog.jpg")
        
        sut?.dogsList = [dog]
        sut?.saveDogsToCoreData()
        
        // THEN
        
        let result = sut?.fetchDogsFromCoreData()
        
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?.first?.dogName, "dog_name")
    }
}

private extension DogsMainInteractorTests {
    func makeInMemoryContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "DogDataModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        let expectation = XCTestExpectation(description: "load persistence store")
        
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
        return container.viewContext
    }
}
