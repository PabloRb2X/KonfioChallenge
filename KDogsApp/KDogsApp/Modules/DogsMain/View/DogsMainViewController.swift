//
//  DogsMainViewController.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import UIKit
import Combine

final class DogsMainViewController: UIViewController {
    
    @IBOutlet private weak var dogsCollectionView: UICollectionView! {
        didSet {
            dogsCollectionView.backgroundColor = .clear
            dogsCollectionView.accessibilityIdentifier = "dogs_collection_view"
            dogsCollectionView.delegate = self
            dogsCollectionView.dataSource = self
            dogsCollectionView.register(UINib(nibName: String(describing: DogViewCell.self), bundle: nil), forCellWithReuseIdentifier: presenter.cellReuseIdentifier)
            if let layout = dogsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumLineSpacing = 32
            }
        }
    }
    
    private let presenter: DogsMainPresenterProtocol
    private var dogsModel: [DogModel] = []
    private var subscriptions = Set<AnyCancellable>()
    private let refreshControl = UIRefreshControl()
    
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

        bind()
        setupNavigationBar()
        setupRefreshControl()
        viewModelInput.viewLoadedPublisher.send()
    }
}

private extension DogsMainViewController {
    func setupNavigationBar() {
        view.backgroundColor = .customWhite
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
            ]
            
            navigationController?.navigationBar.titleTextAttributes = attributes
        }
        
        title = presenter.navTitle
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        dogsCollectionView.refreshControl = refreshControl
    }
    
    func bind() {
        let output = presenter.bind(input: viewModelInput)

        output
            .viewDataPublisher
            .sink { [weak self] _ in
                self?.dismissLoadingView()
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
        
        output
            .endRefreshingPublisher
            .sink { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.dogsCollectionView.refreshControl?.endRefreshing()
                }
            }
            .store(in: &subscriptions)
    }
    
    func fillWithData(viewData: [DogModel]) {
        self.dogsModel = viewData

        dogsCollectionView.reloadData()
    }
    
    @objc func refreshData() {
        presenter.showViewOptionsDataAlert()
    }
}

extension DogsMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogsModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =
                collectionView.dequeueReusableCell(withReuseIdentifier: presenter.cellReuseIdentifier, for: indexPath) as? DogViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setupComponents(dogModel: dogsModel[indexPath.row])
        
        return cell
    }
}

extension DogsMainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: collectionView.bounds.width - 32, height: 175)
    }
}
