//
//  AuthAppNavigationAdapter.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 16/05/21.
//

import SwiftUI
import AuthAppBusinessLogic

final class AuthAppNavigationAdapter {
    private(set) var navigation: NavigationStore
    
    init(navigation: NavigationStore) {
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
