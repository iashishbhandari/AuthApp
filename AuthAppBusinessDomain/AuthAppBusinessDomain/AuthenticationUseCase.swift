//
//  Copyright (c) 2023 Ashish Bhandari
//

import AuthEngine
import Foundation

public final class AuthenticationUseCase {
    private var authFlow: AuthenticationFlow?
    private var output: AuthenticationUseCaseOutput
    
    public init(output: AuthenticationUseCaseOutput) {
        self.output = output
    }
    
    public func authenticate(with credential: LoginCredential? = nil) {
        if let loginCredential = credential {
            self.authFlow = AuthenticationFlow(authType: .credential(loginCredential.toAuthCredential()),
                                               authOutput: self)
        } else {
            self.authFlow = AuthenticationFlow(authType: .device(),
                                               authOutput: self)
        }
        self.authFlow?.start()
    }
}

extension AuthenticationUseCase: AuthenticationOutput {
    public func didAuthenticate(result: Result<AuthToken, AuthError>) {
        switch result {
        case .success(let token):
            output.didComplete(result: .success(.init(token: token)))
        case .failure:
            output.didComplete(result: .failure(.invalidCredentials))
        }
    }
}

public protocol AuthenticationUseCaseOutput {
    func didComplete(result: Result<AuthAppModel, AuthAppError>)
}

public struct AuthAppModel: Equatable {
    public let token: String
}

public enum AuthAppError: Error {
    case invalidCredentials
}

public struct LoginCredential: Hashable {
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
    
    func toAuthCredential() -> AuthCredential {
        .init(username: username, password: password)
    }
}
