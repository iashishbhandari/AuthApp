//  
//  Copyright (c) 2023 Ashish Bhandari
//  

import AuthEngine
import Foundation

public class PersistAuthDataUseCase {
    private var credential: LoginCredential?
    
    public init() {}
    
    public func save(credential: LoginCredential) {
        self.credential = credential
    }
    
    public func get() -> LoginCredential? {
        credential
    }
}

extension PersistAuthDataUseCase: AuthenticationUseCaseOutput {
    public func didComplete(result: Result<AuthAppData, AuthAppError>) {
        if case let .success(authData) = result,
           let credential = authData.credential {
            save(credential: credential)
        }
    }
}
