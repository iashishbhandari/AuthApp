//
//  AuthenticationDataPresenter.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 14/05/21.
//

import AuthAppBusinessDomain

struct ResultViewModel {
    private(set) public var isAuthorised: Bool
    
    public init(isAuthorised: Bool = false) {
        self.isAuthorised = isAuthorised
    }
    
    public var imageName: String {
        isAuthorised ? "lock.open" : "lock"
    }
    public var resultText: String {
        isAuthorised ? "Authorised" : "Not Authorised"
    }
}

protocol AuthDataPresenterOutput {
    func onSuccess(model: ResultViewModel)
    func onFailure(error: (type: AuthAppError, title: String, message: String))
}

final class AuthenticationDataPresenter {
    private var output: AuthDataPresenterOutput
    
    public init(output: AuthDataPresenterOutput) {
        self.output = output
    }
}

extension AuthenticationDataPresenter: AuthenticationUseCaseOutput {
    func didComplete(result: Result<AuthAppModel, AuthAppError>) {
        switch result {
        case .success(let model):
            output.onSuccess(model: ResultViewModel(isAuthorised: !model.token.isEmpty))

        case .failure(let error):
            output.onFailure(error: (type: error, title: "Opps", message: error.localizedDescription))
        }
    }
}
