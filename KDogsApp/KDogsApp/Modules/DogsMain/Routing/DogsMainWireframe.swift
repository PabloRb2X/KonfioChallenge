//
//  DogsMainWireframe.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import UIKit

protocol DogsMainWireframeProtocol {
    func showViewController(presenter: DogsMainPresenterProtocol)
    func showAlert(
        title: String,
        message: String,
        presenter: DogsMainPresenterProtocol
    )
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
        let viewController = DogsMainViewController(
            input: presenter, output: presenter
        )
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showAlert(
        title: String,
        message: String,
        presenter: DogsMainPresenterProtocol
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: { action in
            presenter.retryFetchRequest()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel, handler: nil))
        
        navigationController?.present(alert, animated: true, completion: nil)
    }
}
