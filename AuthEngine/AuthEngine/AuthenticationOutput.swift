//
//  AuthenticationOutput.swift
//  AuthEngine
//
//  Created by Ashish Bhandari - TIL on 13/05/21.
//

import Foundation
import LocalAuthentication

public protocol AuthenticationOutput {
    func didAuthenticate(type: AuthType, result: Result<Void, AuthError>)
}

public enum AuthType: Hashable {
    case device(LAContext = LAContext())
    case remote
}

public enum AuthError: Error {
    case invalidSource
    case invalidCredential
    case unknown
}
