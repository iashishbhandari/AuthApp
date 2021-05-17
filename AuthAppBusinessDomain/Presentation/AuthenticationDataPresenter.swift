//
//  AuthenticationDataPresenter.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 14/05/21.
//

import AuthEngine

public struct ResultViewModel {
    private(set) public var isAuthorised: Bool
    private(set) public var type: AuthType?
    
    public init(isAuthorised: Bool, type: AuthType?) {
        self.isAuthorised = isAuthorised
        self.type = type
    }
    
    public var imageName: String {
        isAuthorised ? "lock.open" : "lock"
    }
    public var resultText: String {
        isAuthorised ? "Authorised" : "Not Authorised"
    }
}

public protocol AuthDataPresenterOutput {
    func onSuccess(model: ResultViewModel)
    func onFailure(error: (type: AuthError, title: String, message: String))
}

public final class AuthenticationDataPresenter {
    private var output: AuthDataPresenterOutput
    
    public init(output: AuthDataPresenterOutput) {
        self.output = output
    }
}

extension AuthenticationDataPresenter: AuthenticationUseCaseOutput {
    public func didComplete(for type: AuthType, result: Result<Bool, AuthError>) {
        switch result {
        case .success(let authenticated):
            output.onSuccess(model: ResultViewModel(isAuthorised: authenticated, type: type))

        case .failure(let error):
            output.onFailure(error: (type: error, title: "Opps", message: error.localizedDescription))
        }
    }
}

