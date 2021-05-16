//
//  AuthDelegate.swift
//  AuthEngine
//
//  Created by Ashish Bhandari - TIL on 13/05/21.
//

import Foundation

public protocol AuthDelegate {
    func didAuthenticate(type: AuthType, result: Result<Bool, AuthError>)
}

public enum AuthType: Hashable {
    case location
    case photo
    case video
}

public enum AuthError: Error {
    case invalidAuthType
    case invalidCredential
    case invalidPolicy
    case unknown
}
