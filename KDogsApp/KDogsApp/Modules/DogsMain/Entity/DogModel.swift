//
//  DogModel.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import Foundation

enum DogAction {
    case reload
    case requestDB
}

struct DogModel: Codable {
    let dogName: String
    let description: String
    let age: Int
    let image: String
}
