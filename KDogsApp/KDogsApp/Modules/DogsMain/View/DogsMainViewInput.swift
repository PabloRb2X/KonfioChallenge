//
//  DogsMainViewInput.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import Foundation
import Combine

struct DogsMainViewInput {
    let viewLoadedPublisher = PassthroughSubject<Void, Never>()
    let viewDidLoadPublisher = PassthroughSubject<Void, Never>()
    let retryPublisher = PassthroughSubject<Void, Never>()
}
