//
//  DogsMainModule.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import UIKit
import CoreData

final class DogsMainModule {
    private var presenter: DogsMainPresenter?
    
    init(with baseController: UIViewController) {
        let wireframe = DogsMainWireframe(with: baseController)
        let interactor = DogsMainInteractor(coreDataContext: getCoreDataContext())
        
        presenter = DogsMainPresenter(interactor: interactor, wireframe: wireframe)
    }
    
    private func getCoreDataContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        return appDelegate.persistentContainer.viewContext
    }
}
