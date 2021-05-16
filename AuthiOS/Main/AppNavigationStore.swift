//
//  AppNavigationStore.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 14/05/21.
//

import SwiftUI
import AuthAppBusinessLogic

enum AppViewType {
    case authenticater
    case loader
}

final class AppNavigationStore: ObservableObject {
    @Published var viewType: AppViewType = .loader
    private var factory: ViewComposerFactory
    
    init(factory: ViewComposerFactory) {
        self.factory = factory
    }
    
    var view: AnyView {
        factory.composedView(for: viewType)
    }
}
