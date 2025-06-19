//
//  DogsMainWireframe.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import UIKit

protocol DogsMainWireframeProtocol {
    func showViewController(presenter: DogsMainPresenterProtocol)
    func showAlert(title: String, message: String, titleButtonOne: String, titleButtonTwo: String)
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
    
    func showAlert(
        title: String, message: String, titleButtonOne: String, titleButtonTwo: String
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: titleButtonOne, style: UIAlertAction.Style.default, handler: { action in
            
            if let dogsVC = self.navigationController?.viewControllers.last as? DogsMainViewController {
                dogsVC.viewModelInput.retryPublisher.send()
            }
        }))
        
        alert.addAction(UIAlertAction(title: titleButtonTwo, style: UIAlertAction.Style.cancel, handler: nil))
        
        navigationController?.present(alert, animated: true, completion: nil)
    }
}

extension DogsMainWireframeProtocol {
    func showAlert(
        title: String,
        message: String,
        titleButtonOne: String = "Aceptar",
        titleButtonTwo: String = "Cancelar"
    ) {
        showAlert(title: title, message: message, titleButtonOne: titleButtonOne, titleButtonTwo: titleButtonTwo)
    }
}
