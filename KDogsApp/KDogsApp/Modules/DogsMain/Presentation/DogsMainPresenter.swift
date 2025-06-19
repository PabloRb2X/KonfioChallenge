//
//  DogsMainPresenter.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import Combine

protocol DogsMainPresenterProtocol: DogsMainViewInput, DogsMainViewOutput {
    func retryFetchRequest()
}

final class DogsMainPresenter {
    // MARK: - Private properties
    
    private let interactor: DogsMainInteractorProtocol
    private let wireframe: DogsMainWireframeProtocol
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let titleErrorMessage = "¡Ha ocurrido un error!"
    private let descriptionErrorMessage = "Ocurrió un error, ¿deseas intentarlo nuevamente?"
    
    // MARK: - Public properties
    
    var dogsList: [DogModel] = []
    
    // MARK: - Functions
    
    init(interactor: DogsMainInteractorProtocol, wireframe: DogsMainWireframeProtocol) {
        self.interactor = interactor
        self.wireframe = wireframe
        
        showViewController()
    }
    
    func showViewController() {
        wireframe.showViewController(presenter: self)
    }
}

extension DogsMainPresenter: DogsMainPresenterProtocol {
    // MARK: - Input properties
    
    var navTitle: String {
        "Dogs We Love"
    }
    
    // MARK: - Input functions
    
    func didLoad() {
        loadViewData()
    }
    
    func retryFetchRequest() {
        
    }
}

private extension DogsMainPresenter {
    func bind() {
        
    }
    
    func loadViewData() {
        interactor
            .fetchDogsList()
            .sink { [weak self] result in
            if case .failure = result {
                
            }
        } receiveValue: { [weak self] model in
            print("model = \(model)")
        }
        .store(in: &subscriptions)
    }
}
