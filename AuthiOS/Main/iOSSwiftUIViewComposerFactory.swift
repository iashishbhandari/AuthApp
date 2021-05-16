//
//  iOSSwiftUIViewComposerFactory.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 16/05/21.
//

import SwiftUI
import AuthAppBusinessLogic

protocol ViewComposerFactory {
    func composedView(for type: AppViewType) -> AnyView
}

final class iOSSwiftUIViewComposerFactory: ViewComposerFactory {
    func composedView(for viewType: AppViewType) -> AnyView {
        switch viewType {
        case .authenticater:
            let viewModel = AuthenticationViewModel()
            let presenter = AuthenticationDataPresenter(output: viewModel)
            let useCase = AuthenticationUseCase(service: RemoteAuthenticationService(), output: presenter)
            viewModel.handler = useCase.authenticate(_:)
            let resetUseCase = ResetAuthStateUseCase(output: AuthiOSApp.navigationAdapter)
            viewModel.resetAction = resetUseCase.reset
            return AnyView(AuthenticationView(viewModel: viewModel))
        case .loader:
            let viewModel = LoaderViewModel()
            let useCase = FinishLoaderUseCase(output: AuthiOSApp.navigationAdapter)
            viewModel.handler = useCase.complete
            return AnyView(LoaderView(viewModel: viewModel))
        }
    }
}
