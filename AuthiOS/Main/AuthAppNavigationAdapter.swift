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
    
    func showLoadingScreen(completion: @escaping () -> Void) {
        let viewModel = LoaderViewModel()
        let useCase = FinishLoaderUseCase(output: completion)
        viewModel.handler = useCase.complete
        navigation.currentView = .loader(viewModel)
    }

    func showLockedScreen() {
        if let _ = AuthAppStore.shared.store.get() {
            let viewModel = LockedViewModel(isAuthorised: false)
            let useCase = DeviceAuthenticationUseCase(output: self)
            viewModel.handler = { useCase.authenticate() }
            withAnimation {
                navigation.currentView = .lock(viewModel)
            }
        } else {
            let viewModel = LockedViewModel(isAuthorised: false)
            let presenter = AuthenticationDataPresenter(output: MainThreadDecorator(decoratee: self))
            let useCase = DeviceAuthenticationUseCase(output: presenter)
            viewModel.handler = { useCase.authenticate() }
            withAnimation {
                navigation.currentView = .lock(viewModel)
            }
        }
    }
    
    func showLoginScreen() {
        let viewModel = LoginViewModel()
        let presenter = AuthenticationDataPresenter(output: MainThreadDecorator(decoratee: self))
        let useCase = CredentialAuthenticationUseCase(output: AuthenticationUseCaseOutputComposite(outputs: [AuthAppStore.shared.store, presenter]))
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

extension AuthAppNavigationAdapter: ResetAuthStateUseCaseOutput {
    func onResetAuthState() {
        showLoadingScreen { [weak self] in
            self?.showLockedScreen()
        }
    }
}

extension AuthAppNavigationAdapter: AuthenticationDataPresenterOutput {
    func onSuccess(data: AuthAppData) {
        if data.token.isEmpty {
            showLoadingScreen { [weak self] in
                self?.showUnLockedScreen()
            }
        } else {
            showLoadingScreen { [weak self] in
                self?.showWelcomeScreen()
            }
        }
    }
    
    func onFailure(error: AuthAppError) {
        navigation.errorVM = .init(error: error)
    }
}

extension AuthAppNavigationAdapter: AuthenticationUseCaseOutput {
    func didComplete(result: Result<AuthAppData, AuthAppError>) {
        switch result {
        case .success(let authData):
            if authData.credential == nil, let credential = AuthAppStore.shared.store.get() {
                let presenter = AuthenticationDataPresenter(output: MainThreadDecorator(decoratee: self))
                let useCase = CredentialAuthenticationUseCase(output: presenter)
                useCase.authenticate(with: credential)
            }
        case .failure(let error):
            navigation.errorVM = .init(error: error)
        }
    }
}

private struct AuthenticationUseCaseOutputComposite: AuthenticationUseCaseOutput {
    let outputs: [AuthenticationUseCaseOutput]
    
    func didComplete(result: Result<AuthAppData, AuthAppError>) {
        outputs.forEach { $0.didComplete(result: result) }
    }
}

private struct MainThreadDecorator: AuthenticationDataPresenterOutput {
    let decoratee: AuthenticationDataPresenterOutput
    
    func onSuccess(data: AuthAppData) {
        runOnMainThread {
            decoratee.onSuccess(data: data)
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
