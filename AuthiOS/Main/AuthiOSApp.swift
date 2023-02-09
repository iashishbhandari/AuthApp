//
//  Copyright (c) 2023 Ashish Bhandari
//

import AuthAppBusinessDomain
import SwiftUI

class AuthAppStore {
    private init() {}
    static let shared = AuthAppStore()
    
    var adaptor: AuthAppNavigationAdapter?
    let store = PersistAuthDataUseCase()
}

@main
struct AuthiOSApp: App {
    @StateObject var navigation = AppNavigationStore()

    var body: some Scene {
        WindowGroup {
            AppNavigationView(store: navigation)
                .onAppear {
                    let adaptor = AuthAppNavigationAdapter(navigation: navigation)
                    AuthAppStore.shared.adaptor = adaptor
                    adaptor.showLockedScreen()
                }
        }
    }
}
