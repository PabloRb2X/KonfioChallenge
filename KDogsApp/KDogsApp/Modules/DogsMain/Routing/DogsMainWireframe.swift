//
//  DogsMainWireframe.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import UIKit

protocol DogsMainWireframeProtocol {
    func showViewController(presenter: DogsMainPresenterProtocol)
    func showAlert(title: String, titleButtonOne: String, viewAction: DogAction, message: String?, titleButtonTwo: String?)
}

final class DogsMainWireframe {
    private weak var baseController: UIViewController?
    
    private var navigationController: UINavigationController? {
        if let navigation = baseController?.presentedViewController as? UINavigationController {
            return navigation
        } else {
            return baseController as? UINavigationController
        }
    }
    
    init(with baseController: UIViewController) {
        self.baseController = baseController
    }
}

extension DogsMainWireframe: DogsMainWireframeProtocol {
    func showViewController(presenter: DogsMainPresenterProtocol) {
        let viewController = DogsMainViewController(presenter: presenter)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showAlert(title: String, titleButtonOne: String, viewAction: DogAction, message: String?, titleButtonTwo: String?) {
        let alert = UIAlertController(
            title: title, message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: titleButtonOne, style: UIAlertAction.Style.default,
                                      handler: { [weak self] action in
            
            if let dogsVC = self?.getDogsMainVC() {
                switch viewAction {
                case .reload:
                    dogsVC.viewModelInput.retryPublisher.send()
                case .requestDB:
                    dogsVC.viewModelInput.queryDBPublisher.send()
                }
            }
        }))
        
        if titleButtonTwo != nil {
            alert.addAction(UIAlertAction(title: titleButtonTwo, style: UIAlertAction.Style.cancel,
                                          handler: { [weak self] action in
                
                if let dogsVC = self?.getDogsMainVC(){
                    switch viewAction {
                    case .requestDB:
                        dogsVC.viewModelInput.retryPublisher.send()
                    default: break
                    }
                }
            }))
        }
        
        navigationController?.present(alert, animated: true, completion: nil)
    }
}

private extension DogsMainWireframe {
    func getDogsMainVC() -> DogsMainViewController? {
        navigationController?.viewControllers.last as? DogsMainViewController
    }
}
