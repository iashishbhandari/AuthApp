//
//  AuthenticationOutput.swift
//  AuthEngine
//
//  Created by Ashish Bhandari - TIL on 13/05/21.
//

import Foundation
import LocalAuthentication

public protocol AuthenticationOutput {
    func didAuthenticate(result: Result<AuthType, AuthError>)
}

public enum AuthType {
    case device(LAContext = LAContext())
    case credential(AuthCredential)
}

public enum AuthError: Error {
    case invalidCredential
    case invalidPolicy
    case invalidSource
}

public struct AuthCredential: Hashable {
    let username: String
    let password: String
    
    public init?(username: String, password: String) {
        if !username.isEmpty && !password.isEmpty && password.rangeOfCharacter(from: .alphanumerics.inverted) == nil {
            self.username = username
            self.password = password
        } else {
            return nil
        }
    }
}
