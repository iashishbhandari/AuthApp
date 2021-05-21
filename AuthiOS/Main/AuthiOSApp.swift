//
//  AuthiOSApp.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 14/05/21.
//

import SwiftUI

@main
struct AuthiOSApp: App {
    static var navigationAdapter = AuthAppNavigationAdapter(navigation: AppNavigationStore())

    var body: some Scene {
        WindowGroup {
            NavigationView(store: AuthiOSApp.navigationAdapter.navigation)
        }
    }
}
