//
//  DeviceAuthenticator.swift
//  AuthEngine
//
//  Created by Ashish Bhandari on 18/01/23.
//

import LocalAuthentication

final class DeviceAuthenticator: AuthenticationSource {
    private var authContext: LAContext
    private var authError: NSError?
    private var authPolicy: LAPolicy?
    
    init(authContext: LAContext = LAContext()) {
        self.authContext = authContext
    }
    
    func canAuthenticate() -> Bool {
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            self.authPolicy = .deviceOwnerAuthenticationWithBiometrics
            return authError == nil
        }
        if authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            self.authPolicy = .deviceOwnerAuthentication
            return authError == nil
        }
        return false
    }
    
    func authenticate(completion: @escaping (Result<AuthType, AuthError>) -> Void) {
        if canAuthenticate(), let policy = authPolicy {
            authContext.evaluatePolicy(policy, localizedReason: "unlock this device!") { success, error in
                if success {
                    completion(.success(.device()))
                } else {
                    completion(.failure(.invalidCredential))
                }
            }
        } else {
            completion(.failure(.invalidPolicy))
        }
    }
}
