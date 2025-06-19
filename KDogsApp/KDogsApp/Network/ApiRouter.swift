//
//  ApiRouter.swift
//  KonfioAppChallenge
//
//  Created by Pablo Ramirez on 18/06/25.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    case fetchDogsList

    func asURLRequest() throws -> URLRequest {
        let url = try ServiceDefinitions.dogsList.asURL()

        switch self {
        case .fetchDogsList:
            var request = URLRequest(url: url)
            request.method = .get
            
            return request
        }
    }
}
