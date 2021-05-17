//
//  AuthenticationUseCase.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 14/05/21.
//

import Foundation

public protocol AuthenticationUseCaseOutput {
    associatedtype T

    func didComplete(for type: AuthAppButtonType, result: Result<T, AuthAppError>)
}

public final class AuthenticationUseCase<Service: AuthenticationService, Output: AuthenticationUseCaseOutput> where Service.Output == Output.T {
    private var service: Service
    private var output: Output
    
    public init(service: Service, output: Output) {
        self.service = service
        self.output = output
    }
    
    public func authenticate(_ type: AuthAppButtonType) {
        service.authenticate(type) {
            self.output.didComplete(for: type, result: $0)
        }
    }
}
