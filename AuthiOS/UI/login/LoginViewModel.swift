//
//  Copyright (c) 2023 Ashish Bhandari
//

import AuthAppBusinessDomain
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""

    var loginAction: ((LoginCredential) -> Void)?
    
    var isValidCredential: Bool {
        LoginCredential(username: email, password: password) != nil
    }
}
