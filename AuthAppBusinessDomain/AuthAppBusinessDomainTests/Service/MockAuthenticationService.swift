//
//  MockAuthenticationService.swift
//  AuthAppBusinessDomainTests
//
//  Created by Ashish Bhandari - TIL on 19/05/21.
//

import Foundation
import AuthAppBusinessDomain

enum MockAuthenticationService: AuthenticationService {
    case success(Bool)
    case failure(AuthAppError)
    
    func authenticate(_ type: AuthAppButtonType, completion: @escaping (Result<Bool, AuthAppError>) -> Void) {
        switch self {
        case .success(let isSuccess):
            completion(.success(isSuccess))
        case .failure(let type):
            completion(.failure(type))
        }
    }
}
