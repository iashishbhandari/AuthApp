//
//  Copyright (c) 2023 Ashish Bhandari
//

import Foundation
import LocalAuthentication

public protocol AuthenticationOutput {
    typealias AuthToken = String
    func didAuthenticate(result: Result<AuthToken, AuthError>)
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

public struct AuthCredential {
    let username: String
    let password: String
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
