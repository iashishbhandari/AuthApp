//
//  iOSSwiftUIViewComposerFactory.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 16/05/21.
//

import AuthAppBusinessDomain

final class iOSSwiftUIViewComposerFactory: AppViewComposerFactory {
    func composedViewModel(for viewType: AppViewType, delegate: AppDelegate) -> AppViewModel {
        switch viewType {
        case .authenticater:
            let viewModel = AuthenticationViewModel()
            let presenter = AuthenticationDataPresenter(output: viewModel)
            let useCase = AuthenticationUseCase(output: presenter)
            viewModel.handler = useCase.authenticate(_:)
            let resetUseCase = ResetAuthStateUseCase(output: delegate)
            viewModel.resetAction = resetUseCase.reset
            return .authenticater(viewModel)
            
        case .loader:
            let viewModel = LoaderViewModel()
            let useCase = FinishLoaderUseCase(output: delegate)
            viewModel.handler = useCase.complete
            return .loader(viewModel)
        }
    }
}
