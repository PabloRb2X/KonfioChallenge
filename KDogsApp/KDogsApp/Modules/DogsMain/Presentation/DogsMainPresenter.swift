//
//  DogsMainPresenter.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import Combine

protocol DogsMainPresenterProtocol {
    var navTitle: String { get }
    var cellReuseIdentifier: String { get }
    var output: DogsMainViewOutput { get }

    func bind(input: DogsMainViewInput) -> DogsMainViewOutput
    func showViewOptionsDataAlert()
}

final class DogsMainPresenter {
    // MARK: - Private properties
    
    private var interactor: DogsMainInteractorProtocol
    private let wireframe: DogsMainWireframeProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    private let titleError = "¡An error has happened!"
    private let titleReload = "¡Look out!"
    private let messageReload = "There is information in the database. Would you like to retry service or query the database?"
    private let retry = "Retry"
    private let retryService = "Retry service"
    private let queryDB = "Query data base"
    
    // MARK: - Public properties
    
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
    
    var navTitle: String {
        "Dogs We Love"
    }
    
    var cellReuseIdentifier: String {
        "dog_cell"
    }
    
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
                self?.output.endRefreshingPublisher.send()
                self?.output.displayLoadingPublisher.send()
                self?.loadViewData()
        }
        .store(in: &self.subscriptions)
        
        input
            .queryDBPublisher
            .sink { [weak self] in
                guard let self = self else { return }
                
                self.output.endRefreshingPublisher.send()
                
                let saveLastDogModel = self.interactor.fetchDogsFromCoreData()
                
                if !saveLastDogModel.isEmpty {
                    self.output.viewDataPublisher.send(saveLastDogModel)
                }
        }
        .store(in: &self.subscriptions)

        return output
    }
    
    func showViewOptionsDataAlert() {
        wireframe.showAlert(
            title: titleReload,
            titleButtonOne: queryDB,
            viewAction: .requestDB,
            message: messageReload,
            titleButtonTwo: retryService
        )
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
                        self.wireframe.showAlert(title: titleError, titleButtonOne: retry, viewAction: .reload, message: nil, titleButtonTwo: nil)
                    }
                }
            } receiveValue: { [weak self] model in
                self?.interactor.dogsList = model
                self?.interactor.saveDogsToCoreData()
                self?.output.viewDataPublisher.send(model)
            }
            .store(in: &subscriptions)
    }
}
