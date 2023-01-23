//
//  AuthenticationSource.swift
//  AuthEngine
//
//  Created by Ashish Bhandari - TIL on 14/05/21.
//

import Foundation

public protocol AuthenticationSource {
    func canAuthenticate() -> Bool
    func authenticate(completion: @escaping (Result<AuthType, AuthError>) -> Void)
}
