//
//  AuthAppNavigationAdapter.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 16/05/21.
//

import AuthAppBusinessDomain
import SwiftUI

final class AuthAppNavigationAdapter<Factory: AppViewComposerFactory> {
    private var factory: Factory
    private var navigation: AppNavigation
    
    init(factory: Factory, navigation: AppNavigation) {
        self.factory = factory
        self.navigation = navigation
    }
    
    func show(viewType: AppViewType, animated: Bool = true) {
        if animated {
            withAnimation {
                navigation.viewType = factory.composedViewModel(for: viewType, delegate: self)
            }
        } else {
            navigation.viewType = factory.composedViewModel(for: viewType, delegate: self)
        }
    }
}

extension AuthAppNavigationAdapter: FinishLoaderUseCaseOutput {
    func onCompleteLoading() {
        show(viewType: .authenticater)
    }
}

extension AuthAppNavigationAdapter: ResetAuthStateUseCaseOutput {
    func onResetAuthState() {
        show(viewType: .loader, animated: false)
    }
}
