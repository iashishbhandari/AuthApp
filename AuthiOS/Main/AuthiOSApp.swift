//
//  Copyright (c) 2023 Ashish Bhandari
//

import SwiftUI

@main
struct AuthiOSApp: App {
    @StateObject var navigation = AppNavigationStore()

    var body: some Scene {
        WindowGroup {
            AppNavigationView(store: navigation)
                .onAppear {
                    AuthAppNavigationAdapter(navigation: navigation).showLockedScreen()
                }
        }
    }
}
