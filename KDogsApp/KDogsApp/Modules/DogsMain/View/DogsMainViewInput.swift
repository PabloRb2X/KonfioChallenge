//
//  DogsMainViewInput.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import Foundation

protocol DogsMainViewInput {
    var navTitle: String { get }
    var dogsList: [DogModel] { get set }
    
    func didLoad()
}
