//
//  DogsMainPresenterTests.swift
//  KDogsAppTests
//
//  Created by Pablo Ramirez on 19/06/25.
//

import XCTest
import Combine
import Alamofire
@testable import KDogsApp

final class DogsMainPresenterTests: XCTestCase {
    
    private let mockSuccessInteractor = MockSuccessDogsMainInteractor()
    private let mockFailureInteractor = MockFailureDogsMainInteractor()
    private let mockWireframe = MockDogsMainWireframe()
    
    private var sut: DogsMainPresenter?
    private var input: DogsMainViewInput?
    private var subscriptions = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        
        input = DogsMainViewInput.mock()
    }
    
    func test_loadViewData_whenRequestIsSuccess_shouldPublishResultAndSaveToCoreData() {
        // GIVEN
        sut = DogsMainPresenter(interactor: mockSuccessInteractor, wireframe: mockWireframe)
        
        let input = DogsMainViewInput.mock()
        let output = sut?.bind(input: input)
        
        var loadingViewShown = false
        var receivedDogs: [DogModel] = []
        let expectation = expectation(description: "successLoadViewData")
        
        output?.displayLoadingPublisher
            .sink {
                loadingViewShown = true
            }
            .store(in: &subscriptions)
        
        output?.viewDataPublisher
            .sink(receiveValue: { dogs in
                receivedDogs = dogs
                expectation.fulfill()
            })
            .store(in: &subscriptions)
        
        // WHEN
        input.viewLoadedPublisher.send(())
        
        // THEN
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(loadingViewShown)
        XCTAssertEqual(receivedDogs.count, 1)
        XCTAssertEqual(receivedDogs.first?.dogName, "dog_name")
        XCTAssertEqual(mockSuccessInteractor.savedDogs.count, 1)
        XCTAssertFalse(mockSuccessInteractor.didCallFetchFromCoreData)
        XCTAssertFalse(mockWireframe.didShowAlert)
    }

    func test_loadViewData_whenRequestFailsAndDBContainsData_shouldPublishFromDBOrShowAlert() {
        // GIVEN
        sut = DogsMainPresenter(interactor: mockFailureInteractor, wireframe: mockWireframe)
        
        let input = DogsMainViewInput.mock()
        let output = sut!.bind(input: input)
        
        var loadingViewShown = false
        var dataReceived = false
        let expectation = expectation(description: "failureLoadViewData")
        
        output.displayLoadingPublisher
            .sink {
                loadingViewShown = true
            }
            .store(in: &subscriptions)
        
        output.viewDataPublisher
            .sink(receiveValue: { _ in
                dataReceived = true
                expectation.fulfill()
            })
            .store(in: &subscriptions)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            if ((self?.mockWireframe.didShowAlert) != nil) {
                expectation.fulfill()
            }
        }
        
        // WHEN
        input.viewLoadedPublisher.send(())
        
        // THEN
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(loadingViewShown)
        XCTAssertTrue(dataReceived || mockWireframe.didShowAlert)
    }
    
    func test_whenShowViewOptionsDataAlertIsCalled_shouldShowAlert() {
        // GIVEN
        sut = DogsMainPresenter(interactor: mockSuccessInteractor, wireframe: mockWireframe)
        
        // WHEN
        sut?.showViewOptionsDataAlert()
        
        // THEN
        XCTAssertTrue(mockWireframe.didShowAlert)
    }
    
    func test_whenShowViewOontrollerIsCalled_shouldShowVC() {
        // GIVEN
        sut = DogsMainPresenter(interactor: mockSuccessInteractor, wireframe: mockWireframe)
        
        // WHEN
        sut?.showViewController()
        
        // THEN
        XCTAssertTrue(mockWireframe.didShowViewController)
    }
}

extension DogsMainViewInput {
    static func mock(
        viewLoaded: PassthroughSubject<Void, Never> = .init(),
        retry: PassthroughSubject<Void, Never> = .init(),
        queryDB: PassthroughSubject<Void, Never> = .init()
    ) -> DogsMainViewInput {
        var input = DogsMainViewInput()
        input.viewLoadedPublisher = viewLoaded
        input.retryPublisher = retry
        input.queryDBPublisher = queryDB
        
        return input
    }
}
