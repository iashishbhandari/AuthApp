//
//  AuthAppNavigationAdapter.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 16/05/21.
//

import SwiftUI
import AuthAppBusinessLogic

final class AuthAppNavigationAdapter {
    private(set) var navigation: AppNavigationStore
    
    init(navigation: AppNavigationStore) {
        self.navigation = navigation
    }
    
    func show(viewType: AppViewType, animated: Bool = true) {
        if animated {
            withAnimation {
                navigation.viewType = viewType
            }
        } else {
            navigation.viewType = viewType
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
