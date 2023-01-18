//
//  AuthenticationFlow.swift
//  AuthEngine
//
//  Created by Ashish Bhandari - TIL on 13/05/21.
//

import Foundation

final public class AuthenticationFlow {
    let authType: AuthType
    let authOutput: AuthenticationOutput
        
    public init(authType: AuthType, authOutput: AuthenticationOutput) {
        self.authType = authType
        self.authOutput = authOutput
    }
    
    public func start() {
        switch authType {
        case .device(let context):
            let authSource = DeviceAuthenticator(authContext: context)
            if authSource.canAuthenticate() {
                authSource.authenticate { [authOutput, authType] in
                    authOutput.didAuthenticate(type: authType, result: $0)
                }
            } else {
                authOutput.didAuthenticate(type: authType, result: .failure(.invalidSource))
            }
        case .remote:
            authOutput.didAuthenticate(type: authType, result: .failure(.invalidSource))
        }
    }
}
