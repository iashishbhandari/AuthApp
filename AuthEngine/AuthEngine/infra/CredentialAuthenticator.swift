//
//  CredentialAuthenticator.swift
//  AuthEngine
//
//  Created by Ashish Bhandari on 22/01/23.
//

import Foundation

final class CredentialAuthenticator: AuthenticationSource {
    struct Credential {
        let userName: String
        let password: String
    }
    
    let credentialResolver: () -> Credential
        
    init(credentialResolver: @escaping () -> Credential) {
        self.credentialResolver = credentialResolver
    }
    
    func canAuthenticate() -> Bool {
        let credential = credentialResolver()
        return !credential.userName.isEmpty && !credential.password.isEmpty
    }
    
    func authenticate(completion: @escaping (Result<AuthType, AuthError>) -> Void) {
        let credential = credentialResolver()
        performAuthetication(credential) {
            switch $0 {
            case .success:
                completion(.success(.credential(.init(username: credential.userName, password: credential.password)!)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func performAuthetication(_ credential: Credential,
            completion: @escaping (Result<Void, AuthError>) -> Void) {
        if credential.password == "password2" {
            completion(.success(()))
        } else {
            completion(.failure(.invalidCredential))
        }
    }
}

final class AsynchonousCredentialAuthenticator: AuthenticationSource {
    let source: AuthenticationSource

    init(source: AuthenticationSource) {
        self.source = source
    }
    
    func canAuthenticate() -> Bool {
        source.canAuthenticate()
    }
    
    func authenticate(completion: @escaping (Result<AuthType, AuthError>) -> Void) {
        DispatchQueue.global(qos: .background).async { [source, completion] in
            source.authenticate { result in
                DispatchQueue.main.async { completion(result) }
            }
        }
    }
}
