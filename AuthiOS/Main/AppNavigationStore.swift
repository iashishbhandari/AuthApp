//
//  AppNavigationStore.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 14/05/21.
//

import SwiftUI

protocol AppNavigation {
    var viewType: AppViewModel? {get set}
}

final class AppNavigationStore: ObservableObject, AppNavigation {
    @Published var viewType: AppViewModel?

    var view: AnyView {
        switch viewType {
        case .authenticater(let model):
            return AnyView(AuthenticationView(viewModel: model))
        case .loader(let model):
            return AnyView(LoaderView(viewModel: model))
        case .none:
            return AnyView(EmptyView())
        }
    }
}
