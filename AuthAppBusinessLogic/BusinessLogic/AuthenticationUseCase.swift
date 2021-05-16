//
//  AuthenticationUseCase.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 14/05/21.
//

import AuthEngine

public protocol AuthenticationUseCaseOutput {
    func didComplete(for type: AuthType, result: Result<Bool, AuthError>)
}

public final class AuthenticationUseCase {
    private var service: AuthenticationService
    private var output: AuthenticationUseCaseOutput
    
    public init(service: AuthenticationService, output: AuthenticationUseCaseOutput) {
        self.service = service
        self.output = output
    }
    
    public func authenticate(_ type: AuthType) {
        service.authenticate(type) {
            self.output.didComplete(for: type, result: $0)
        }
    }
}
