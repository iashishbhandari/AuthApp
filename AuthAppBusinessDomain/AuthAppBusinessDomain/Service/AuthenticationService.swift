//
//  AuthenticationService.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 14/05/21.
//

import AuthEngine

public protocol AuthenticationService {
    associatedtype Output
    
    func authenticate(_ type: AuthAppButtonType, completion: @escaping (Result<Output, AuthAppError>) -> Void)
}

public final class RemoteAuthenticationService: AuthenticationService {
    private(set) var authContext: AuthContext<RemoteAuthenticationService>?
    private(set) var completion: ((Result<Bool, AuthAppError>) -> Void)?
    
    public init() {}

    public func authenticate(_ type: AuthAppButtonType, completion: @escaping (Result<Bool, AuthAppError>) -> Void) {
        authContext = AuthContext.authenticate(for: getAuthType(from: type), delegate: self)
        self.completion = completion
    }
    
    func getAuthType(from type: AuthAppButtonType) -> AuthType {
        switch type {
        case .location:
            return .location
        case .photo:
            return .photo
        case .video:
            return .video
        }
    }
}

extension RemoteAuthenticationService: AuthDelegate {
    public func didAuthenticate(type: AuthType, result: Result<Bool, AuthError>) {
        switch result {
        case .success(let authenticated):
            completion?(.success(authenticated))
        case .failure:
            completion?(.failure(.serviceError))
        }
    }
}
