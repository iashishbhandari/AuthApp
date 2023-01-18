//
//  AuthiOSApp.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 14/05/21.
//

import SwiftUI

@main
struct AuthiOSApp: App {
    @StateObject var navigation = AppNavigationStore()
    private var appStore = AuthAppStore()

    var body: some Scene {
        WindowGroup {
            NavigationView(store: navigation)
                .onAppear {
                    appStore.adapter = AuthAppNavigationAdapter(factory: iOSSwiftUIViewComposerFactory(), navigation: navigation)
                    appStore.adapter?.show(viewType: .loader)
                }
        }
    }
}

class AuthAppStore {
    var adapter: AuthAppNavigationAdapter<iOSSwiftUIViewComposerFactory>?
}
