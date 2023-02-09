//
//  Copyright (c) 2023 Ashish Bhandari
//

import AuthEngine

public final class CredentialAuthenticationUseCase {
    private var authFlow: AuthenticationFlow?
    private var loginCredentials: LoginCredential?
    private var output: AuthenticationUseCaseOutput

    public init(output: AuthenticationUseCaseOutput) {
        self.output = output
    }
    
    public func authenticate(with loginCredentials: LoginCredential) {
        self.loginCredentials = loginCredentials
        self.authFlow = AuthenticationFlow(authType: .credential(loginCredentials.toAuthCredential()),
                                           authOutput: self)
        self.authFlow?.start()
    }
}

extension CredentialAuthenticationUseCase: AuthenticationOutput {
    public func didAuthenticate(result: Result<AuthToken, AuthError>) {
        switch result {
        case .success(let token):
            output.didComplete(result: .success(.init(token: token, credential: self.loginCredentials)))
        case .failure:
            output.didComplete(result: .failure(.invalidCredentials))
        }
    }
}

public protocol AuthenticationUseCaseOutput {
    func didComplete(result: Result<AuthAppData, AuthAppError>)
}

public struct AuthAppData: Equatable {
    public let token: String
    public let credential: LoginCredential?
    
    public init(token: String, credential: LoginCredential? = nil) {
        self.token = token
        self.credential = credential
    }
}

public enum AuthAppError: Error {
    case invalidCredentials
    case noData
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
