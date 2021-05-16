//
//  AuthenticationService.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 14/05/21.
//

import AuthEngine

public protocol AuthenticationService {
    func authenticate(_ type: AuthType, completion: @escaping (Result<Bool, AuthError>) -> Void)
}

public final class RemoteAuthenticationService: AuthenticationService {
    private(set) var authContext: AuthContext<RemoteAuthenticationService>?
    private(set) var completion: ((Result<Bool, AuthError>) -> Void)?
    
    public init() {}

    public func authenticate(_ type: AuthType, completion: @escaping (Result<Bool, AuthError>) -> Void) {
        authContext = AuthContext.authenticate(for: type, delegate: self)
        self.completion = completion
    }
}

extension RemoteAuthenticationService: AuthDelegate {
    public func didAuthenticate(type: AuthType, result: Result<Bool, AuthError>) {
        completion?(result)
    }
}
