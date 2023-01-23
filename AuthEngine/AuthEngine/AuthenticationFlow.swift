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
        var authSource: AuthenticationSource
        switch authType {
        case .device(let context):
            authSource = DeviceAuthenticator(authContext: context)
            
        case .credential(let authCredential):
            authSource = AsynchonousCredentialAuthenticator(source: CredentialAuthenticator {
                .init(userName: authCredential.username,
                      password: authCredential.password)
            })
        }
        if authSource.canAuthenticate() {
            authSource.authenticate { [authOutput] in
                switch $0 {
                case .success(let authType):
                    authOutput.didAuthenticate(result: .success(authType))
                case .failure(let error):
                    authOutput.didAuthenticate(result: .failure(error))
                }
            }
        } else {
            authOutput.didAuthenticate(result: .failure(.invalidSource))
        }
    }
}
