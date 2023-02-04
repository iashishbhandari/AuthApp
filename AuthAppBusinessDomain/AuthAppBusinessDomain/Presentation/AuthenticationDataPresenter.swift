//
//  Copyright (c) 2023 Ashish Bhandari
//

public protocol AuthenticationDataPresenterOutput {
    func onSuccess(data: AuthAppData)
    func onFailure(error: AuthAppError)
}

public final class AuthenticationDataPresenter {
    private var output: AuthenticationDataPresenterOutput
    
    public init(output: AuthenticationDataPresenterOutput) {
        self.output = output
    }
}

extension AuthenticationDataPresenter: AuthenticationUseCaseOutput {
    public func didComplete(result: Result<AuthAppData, AuthAppError>) {
        switch result {
        case .success(let data):
            output.onSuccess(data: data)
        case .failure(let error):
            output.onFailure(error: error)
        }
    }
}
