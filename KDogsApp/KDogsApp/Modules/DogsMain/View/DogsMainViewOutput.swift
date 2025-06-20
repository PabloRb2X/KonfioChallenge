//
//  DogsMainViewOutput.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import Combine

struct DogsMainViewOutput {
    let viewDataPublisher = PassthroughSubject<[DogModel], Never>()
    let didTapBackButtonPublisher = PassthroughSubject<Void, Never>()
    let navigateToDetailsViewPublisher = PassthroughSubject<Void, Never>()
    let displayLoadingPublisher = PassthroughSubject<Void, Never>()
    let endRefreshingPublisher = PassthroughSubject<Void, Never>()
}
