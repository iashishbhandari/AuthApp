//
//  Copyright (c) 2023 Ashish Bhandari
//

import AuthAppBusinessDomain
import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""

    var loginAction: ((LoginCredential) -> Void)?
    
    var isValidCredential: Bool {
        LoginCredential(username: email, password: password) != nil
    }
}
