//
//  AuthenticationUseCase.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 14/05/21.
//

import AuthEngine
import Foundation
import LocalAuthentication

public final class AuthenticationUseCase {
    private var authContext: LAContext
    private var authFlow: AuthenticationFlow?
    private var buttonType: AuthAppButtonType?
    private var output: AuthenticationUseCaseOutput
    
    convenience init(authContext: LAContext, output: AuthenticationUseCaseOutput) {
        self.init(output: output)
        self.authContext = authContext
    }

    public init(output: AuthenticationUseCaseOutput) {
        self.authContext = LAContext()
        self.output = output
    }
    
    public func authenticate(_ type: AuthAppButtonType) {
        self.buttonType = type
        switch type {
        case .unlock:
            self.authFlow = AuthenticationFlow(authType: .device(authContext), authOutput: self)
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
            output.didComplete(for: buttonType!,
                               result: .success(.init(token: UUID().uuidString)))
        case .failure:
            output.didComplete(for: buttonType!,
                               result: .failure(.invalidCredentials))
        }
    }
}

public protocol AuthenticationUseCaseOutput {
    func didComplete(for type: AuthAppButtonType, result: Result<AuthAppModel, AuthAppError>)
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
