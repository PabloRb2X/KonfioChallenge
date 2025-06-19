//
//  DogsMainModule.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import UIKit

final class DogsMainModule {
    private let presenter: DogsMainPresenter
    
    init(with baseController: UIViewController) {
        let wireframe = DogsMainWireframe(with: baseController)
        let interactor = DogsMainInteractor()
        
        presenter = DogsMainPresenter(interactor: interactor, wireframe: wireframe)
    }
}
