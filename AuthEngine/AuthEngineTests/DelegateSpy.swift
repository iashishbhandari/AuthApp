//
//  DelegateSpy.swift
//  AuthEngineTests
//
//  Created by Ashish Bhandari - TIL on 13/05/21.
//

import Foundation
@testable import AuthEngine

final class DelegateSpy: AuthDelegate {
    var callback: (() -> Void)?
    var results = [Result<Bool, AuthError>]()
    
    init(callback: (() -> Void)? = nil) {
        self.callback = callback
    }
    
    func didAuthenticate(type: AuthType, result: Result<Bool, AuthError>) {
        results.append(result)
        callback?()
    }
}

func syncAuthentication(_ completion: @escaping (Result<Bool, AuthError>) -> Void) {
    completion(.success(true))
}

func syncAuthenticationFailure(_ completion: @escaping (Result<Bool, AuthError>) -> Void) {
    completion(.success(false))
}
