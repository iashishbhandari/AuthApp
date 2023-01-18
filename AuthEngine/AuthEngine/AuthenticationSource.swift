//
//  AuthenticationSource.swift
//  AuthEngine
//
//  Created by Ashish Bhandari - TIL on 14/05/21.
//

import Foundation

protocol AuthenticationSource {
    func canAuthenticate() -> Bool
    func authenticate(completion: @escaping (Result<Void, AuthError>) -> Void)
}
