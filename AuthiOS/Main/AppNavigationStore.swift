//
//  AppNavigationStore.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 14/05/21.
//

import SwiftUI

final class AppNavigationStore: ObservableObject {
    @Published var viewType: AppViewType = .loader
    @ViewFactory var factory = iOSSwiftUIViewComposerFactory()

    var view: AnyView {
        factory.composedView(for: viewType)
    }
}
