//
//  Copyright (c) 2023 Ashish Bhandari
//

public protocol AuthDataPresenterOutput {
    func onSuccess(model: AuthAppModel)
    func onFailure(error: AuthAppError)
}

public final class AuthenticationDataPresenter {
    private var output: AuthDataPresenterOutput
    
    public init(output: AuthDataPresenterOutput) {
        self.output = output
    }
}

extension AuthenticationDataPresenter: AuthenticationUseCaseOutput {
    public func didComplete(result: Result<AuthAppModel, AuthAppError>) {
        switch result {
        case .success(let model):
            output.onSuccess(model: model)
        case .failure(let error):
            output.onFailure(error: error)
        }
    }
}
