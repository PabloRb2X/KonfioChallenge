//
//  DogsMainViewController.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import UIKit
import Combine

final class DogsMainViewController: UIViewController {
    
    @IBOutlet private weak var dogsCollectionView: UICollectionView!
    
    private let presenter: DogsMainPresenterProtocol
    private var dogsModel: [DogModel] = []
    private var subscriptions = Set<AnyCancellable>()
    
    let viewModelInput: DogsMainViewInput = DogsMainViewInput()

    init(presenter: DogsMainPresenterProtocol) {
        self.presenter = presenter
        
        super.init(
            nibName: String(describing: DogsMainViewController.self),
            bundle: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        bind()
        viewModelInput.viewLoadedPublisher.send()
    }
}

private extension DogsMainViewController {
    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.tintColor = UIColor.customBlack
        backButton.sizeToFit()

        let backBarItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarItem
        
        if let arialFont = UIFont(name: "Arial-BoldMT", size: 20) {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: arialFont,
                .foregroundColor: UIColor.customBlack
            ]
            
            navigationController?.navigationBar.titleTextAttributes = attributes
        }
        
        title = presenter.navTitle
    }
    
    func bind() {
        let output = presenter.bind(input: viewModelInput)

        output
            .viewDataPublisher
            .sink { [weak self] _ in
                self?.dismissLoadingView()
                output.displayErrorAlertPublisher.send()
            } receiveValue: { [weak self] in
                self?.dismissLoadingView()
                self?.fillWithData(viewData: $0)
            }
            .store(in: &subscriptions)

        output
            .displayLoadingPublisher
            .sink { [weak self] in
                self?.showLoadingView()
            }
            .store(in: &subscriptions)
    }
    
    private func fillWithData(viewData: [DogModel]) {
        self.dogsModel = viewData

        // crear celda y actualizar collectionview
    }
}
