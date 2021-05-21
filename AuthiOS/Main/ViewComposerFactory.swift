//
//  ViewComposerFactory.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 21/05/21.
//

import SwiftUI

protocol ViewComposerFactory {
    func composedView(for type: AppViewType) -> AnyView
}

enum AppViewType {
    case authenticater
    case loader
}

@propertyWrapper
struct ViewFactory {
    var wrappedValue: ViewComposerFactory
    
    init(wrappedValue: ViewComposerFactory) {
        self.wrappedValue = wrappedValue
    }
}
