//  
//  Copyright (c) 2023 Ashish Bhandari
//  

import AuthEngine

public final class DeviceAuthenticationUseCase {
    private var authFlow: AuthenticationFlow?
    private var output: AuthenticationUseCaseOutput

    public init(output: AuthenticationUseCaseOutput) {
        self.output = output
    }
    
    public func authenticate() {
        self.authFlow = AuthenticationFlow(authType: .device(),
                                           authOutput: self)
        self.authFlow?.start()
    }
}

extension DeviceAuthenticationUseCase: AuthenticationOutput {
    public func didAuthenticate(result: Result<AuthToken, AuthError>) {
        switch result {
        case .success(let token):
            output.didComplete(result: .success(.init(token: token, credential: nil)))
        case .failure:
            output.didComplete(result: .failure(.invalidCredentials))
        }
    }
}
