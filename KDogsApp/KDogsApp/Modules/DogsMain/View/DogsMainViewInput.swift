//
//  DogsMainViewInput.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import Foundation
import Combine

struct DogsMainViewInput {
    var viewLoadedPublisher = PassthroughSubject<Void, Never>()
    var retryPublisher = PassthroughSubject<Void, Never>()
    var queryDBPublisher = PassthroughSubject<Void, Never>()
}
