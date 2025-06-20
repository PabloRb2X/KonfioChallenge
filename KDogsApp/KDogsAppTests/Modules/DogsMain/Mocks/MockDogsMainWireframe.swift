//
//  MockDogsMainWireframe.swift
//  KDogsAppTests
//
//  Created by Pablo Ramirez on 19/06/25.
//

import Foundation
@testable import KDogsApp

final class MockDogsMainWireframe: DogsMainWireframeProtocol {
    var didShowViewController = false
    var didShowAlert = false
    
    func showViewController(presenter: DogsMainPresenterProtocol) {
        didShowViewController = true
    }

    func showAlert(
        title: String, titleButtonOne: String, viewAction: DogAction, message: String?, titleButtonTwo: String?
    ) {
        didShowAlert = true
    }
}
