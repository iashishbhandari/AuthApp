//
//  Copyright (c) 2023 Ashish Bhandari
//

import Foundation

public protocol AuthenticationSource {
    func canAuthenticate() -> Bool
    func authenticate(completion: @escaping (Result<AuthType, AuthError>) -> Void)
}
