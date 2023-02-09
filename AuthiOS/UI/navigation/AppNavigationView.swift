//
//  Copyright (c) 2023 Ashish Bhandari
//

import AuthAppBusinessDomain
import SwiftUI

struct AppNavigationView: View {
    @ObservedObject var store: AppNavigationStore
    
    var body: some View {
        store.view
            .transition(
                AnyTransition
                    .opacity
                    .combined(with: .move(edge: .trailing))
            )
            .id(UUID())
            .alert(item: $store.errorVM) {
                Alert(title: Text(AppConstants.alertTitleText),
                      message: Text($0.message),
                      dismissButton: .default(Text(AppConstants.okButtonText)))
            }
    }
}

final class AppNavigationStore: ObservableObject {
    enum CurrentView {
        case lock(LockedViewModel)
        case loader(LoaderViewModel)
        case unlock(LoginViewModel)
        case welcome(WelcomeViewModel)
    }
    @Published var currentView: CurrentView?
    @Published var errorVM: AppErrorViewModel?

    var view: AnyView {
        switch currentView {
        case let .lock(model):
            return AnyView(LockedView(viewModel: model))
        case .loader(let model):
            return AnyView(LoaderView(viewModel: model))
        case let .unlock(model):
            return AnyView(LoginView(viewModel: model))
        case let .welcome(model):
            return AnyView(WelcomeView(viewModel: model))
        case .none:
            return AnyView(EmptyView())
        }
    }
    
    struct AppErrorViewModel: Identifiable {
        let id = UUID()
        var message: String = AppConstants.somethingWentWrongText
        
        init(error: AuthAppError) {
            switch error {
            case .invalidCredentials:
                message = AppConstants.wrongCredentialsText
            case .noData:
                message = AppConstants.somethingWentWrongText
            }
        }
    }
}
