//
//  DogsMainPresenter.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import Combine

protocol DogsMainPresenterProtocol {
    var navTitle: String { get }
    var output: DogsMainViewOutput { get }
    var dogsList: [DogModel] { get }

    func bind(input: DogsMainViewInput) -> DogsMainViewOutput
}

final class DogsMainPresenter {
    // MARK: - Private properties
    
    private var interactor: DogsMainInteractorProtocol
    private let wireframe: DogsMainWireframeProtocol
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let titleErrorMessage = "¡Ha ocurrido un error!"
    private let descriptionErrorMessage = "Ocurrió un error, ¿deseas intentarlo nuevamente?"
    
    // MARK: - Public properties
    
    var dogsList: [DogModel] = []
    var output = DogsMainViewOutput()
    
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
    func bind(input: DogsMainViewInput) -> DogsMainViewOutput {
        input
            .viewLoadedPublisher
            .sink { [weak self] in
                self?.output.displayLoadingPublisher.send()
                self?.loadViewData()
        }
        .store(in: &self.subscriptions)

        input
            .retryPublisher
            .sink { [weak self] in
                self?.output.displayLoadingPublisher.send()
                self?.loadViewData()
        }
        .store(in: &self.subscriptions)

        return output
    }
}

private extension DogsMainPresenter {
    func loadViewData() {
        interactor
            .fetchDogsList()
            .sink { [weak self] result in
                guard let self = self else { return }
                
                if case .failure = result {
                    let saveLastDogModel = self.interactor.fetchDogsFromCoreData()
                    
                    if !saveLastDogModel.isEmpty {
                        self.output.viewDataPublisher.send(saveLastDogModel)
                    } else {
                        self.wireframe.showAlert(
                            title: "Ha ocurrido un error",
                            message: "No se pudo cargar la información. Vuelva a intentarlo."
                        )
                    }
                }
            } receiveValue: { [weak self] model in
                self?.interactor.dogsList = model
                self?.interactor.saveDogsToCoreData(model)
                self?.output.viewDataPublisher.send(model)
            }
            .store(in: &subscriptions)
    }
}
