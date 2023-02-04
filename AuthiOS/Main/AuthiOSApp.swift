//
//  Copyright (c) 2023 Ashish Bhandari
//

import AuthAppBusinessDomain
import SwiftUI

class AuthAppStore {
    private init() {}
    static let shared = AuthAppStore()
    
    let store: PersistAuthDataUseCase = PersistAuthDataUseCase()
    var adaptor: AuthAppNavigationAdapter?
}

@main
struct AuthiOSApp: App {
    @StateObject var navigation = AppNavigationStore()

    var body: some Scene {
        WindowGroup {
            AppNavigationView(store: navigation)
                .onAppear {
                    let adaptor = AuthAppNavigationAdapter(navigation: navigation)
                    adaptor.showLoadingScreen {
                        adaptor.showLockedScreen()
                    }
                    AuthAppStore.shared.adaptor = adaptor
                }
        }
    }
}
