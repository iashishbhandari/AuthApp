//
//  Copyright (c) 2023 Ashish Bhandari
//

import Foundation

final class CredentialAuthenticator: AuthenticationSource {
    let credentialResolver: () -> AuthCredential
        
    init(credentialResolver: @escaping () -> AuthCredential) {
        self.credentialResolver = credentialResolver
    }
    
    func canAuthenticate() -> Bool {
        let credential = credentialResolver()
        return !credential.username.isEmpty && !credential.password.isEmpty
    }
    
    func authenticate(completion: @escaping (Result<AuthType, AuthError>) -> Void) {
        let credential = credentialResolver()
        performAuthetication(credential) {
            switch $0 {
            case .success:
                completion(.success(.credential(credential)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func performAuthetication(_ credential: AuthCredential,
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
