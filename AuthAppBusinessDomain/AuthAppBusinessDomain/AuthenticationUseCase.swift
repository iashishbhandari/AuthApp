//
//  AuthenticationUseCase.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 14/05/21.
//

import AuthEngine
import Foundation

public final class AuthenticationUseCase {
    private var authFlow: AuthenticationFlow?
    private var output: AuthenticationUseCaseOutput
    
    public init(output: AuthenticationUseCaseOutput) {
        self.output = output
    }
    
    public func authenticate(_ type: AuthAppButtonType) {
        switch type {
        case .unlock:
            self.authFlow = AuthenticationFlow(authType: .device(), authOutput: self)
        case .login:
            self.authFlow = AuthenticationFlow(authType: .remote, authOutput: self)
        }
        self.authFlow?.start()
    }
}

extension AuthenticationUseCase: AuthenticationOutput {
    public func didAuthenticate(type: AuthEngine.AuthType, result: Result<Void, AuthEngine.AuthError>) {
        switch result {
        case .success:
            output.didComplete(result: .success(.init(token: UUID().uuidString)))
        case .failure:
            output.didComplete(result: .failure(.invalidCredentials))
        }
    }
}

public protocol AuthenticationUseCaseOutput {
    func didComplete(result: Result<AuthAppModel, AuthAppError>)
}

public struct AuthAppModel {
    public let token: String
}

public enum AuthAppButtonType: String {
    case unlock = "Unlock the App!"
    case login = "Sign In to continue!"
}

public enum AuthAppError: Error {
    case invalidCredentials
    case unknown
}
