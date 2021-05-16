//
//  AuthPolicy.swift
//  AuthEngine
//
//  Created by Ashish Bhandari - TIL on 14/05/21.
//

import Foundation

typealias Authenticater<T> = (@escaping (T) -> Void) -> Void

protocol AuthPolicy {
    func canEvaluatePolicy(_ type: AuthType) -> Bool
    func evaluatePolicy(with delegate: AuthDelegate)
}


struct LocationPolicy: AuthPolicy {
    let authenticate: Authenticater<Result<Bool, AuthError>>
    
    func canEvaluatePolicy(_ type: AuthType) -> Bool {
        type == .location
    }
    
    func evaluatePolicy(with delegate: AuthDelegate) {
        authenticate() {
            delegate.didAuthenticate(type: .location, result: $0)
        }
    }
}

struct PhotoPolicy: AuthPolicy {
    let authenticate: Authenticater<Result<Bool, AuthError>>

    func canEvaluatePolicy(_ type: AuthType) -> Bool {
        type == .photo
    }
    
    func evaluatePolicy(with delegate: AuthDelegate) {
        authenticate() {
            delegate.didAuthenticate(type: .photo, result: $0)
        }
    }
}

struct VideoPolicy: AuthPolicy {
    let authenticate: Authenticater<Result<Bool, AuthError>>

    func canEvaluatePolicy(_ type: AuthType) -> Bool {
        type == .video
    }
    
    func evaluatePolicy(with delegate: AuthDelegate) {
        authenticate() {
            delegate.didAuthenticate(type: .video, result: $0)
        }
    }
}
