//
//  Copyright (c) 2023 Ashish Bhandari
//

import AuthAppBusinessDomain
import SwiftUI

final class AuthAppNavigationAdapter {
    private var navigation: AppNavigationStore
    
    init(navigation: AppNavigationStore) {
        self.navigation = navigation
    }
    
    func showLoadingScreen() {
        let viewModel = LoaderViewModel()
        let useCase = FinishLoaderUseCase(output: self)
        viewModel.handler = useCase.complete
        navigation.currentView = .loader(viewModel)
    }

    func showLockedScreen() {
        let viewModel = LockedViewModel(isAuthorised: false)
        let presenter = AuthenticationDataPresenter(output: MainThreadDecorator(decoratee: self))
        let useCase = AuthenticationUseCase(output: presenter)
        viewModel.handler = { useCase.authenticate() }
        let resetUseCase = ResetAuthStateUseCase(output: self)
        viewModel.resetAction = resetUseCase.reset
        withAnimation {
            navigation.currentView = .lock(viewModel)
        }
    }
    
    func showLoginScreen() {
        let viewModel = LoginViewModel()
        let presenter = AuthenticationDataPresenter(output: MainThreadDecorator(decoratee: self))
        let useCase = AuthenticationUseCase(output: presenter)
        viewModel.loginAction = { useCase.authenticate(with: $0) }
        withAnimation {
            navigation.currentView = .unlock(viewModel)
        }
    }
    
    func showUnLockedScreen() {
        let viewModel = LockedViewModel(isAuthorised: true)
        viewModel.handler = { [weak self] in
            self?.showLoginScreen()
        }
        let resetUseCase = ResetAuthStateUseCase(output: self)
        viewModel.resetAction = resetUseCase.reset
        withAnimation {
            navigation.currentView = .lock(viewModel)
        }
    }
    
    func showWelcomeScreen() {
        withAnimation {
            navigation.currentView = .welcome
        }
    }
}

extension AuthAppNavigationAdapter: FinishLoaderUseCaseOutput {
    func onCompleteLoading() {
        showLockedScreen()
    }
}

extension AuthAppNavigationAdapter: ResetAuthStateUseCaseOutput {
    func onResetAuthState() {
        showLoadingScreen()
    }
}

extension AuthAppNavigationAdapter: AuthDataPresenterOutput {
    func onSuccess(model: AuthAppModel) {
        model.token.isEmpty ? showUnLockedScreen() : showWelcomeScreen()
    }
    
    func onFailure(error: AuthAppError) {
        navigation.errorVM = .init(error: error)
    }
}

private struct MainThreadDecorator: AuthDataPresenterOutput {
    let decoratee: AuthDataPresenterOutput
    
    func onSuccess(model: AuthAppModel) {
        runOnMainThread {
            decoratee.onSuccess(model: model)
        }
    }
    
    func onFailure(error: AuthAppError) {
        runOnMainThread {
            decoratee.onFailure(error: error)
        }
    }
    
    private func runOnMainThread(execute: @escaping () -> Void) {
        if Thread.isMainThread {
            execute()
        } else {
            DispatchQueue.main.async { execute() }
        }
    }
}
