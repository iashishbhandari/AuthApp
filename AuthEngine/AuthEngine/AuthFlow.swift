//
//  AuthFlow.swift
//  AuthEngine
//
//  Created by Ashish Bhandari - TIL on 13/05/21.
//

import Foundation

final class AuthFlow<Delegate: AuthDelegate> {
    let type: AuthType
    let delegate: Delegate
    let policies: [AuthType: AuthPolicy]
        
    init(_ type: AuthType, _ router: Delegate, _ policies: [AuthType: AuthPolicy] = defaultPolicies) {
        self.type = type
        self.delegate = router
        self.policies = policies
    }
    
    func start() {
        if let policy = policies[type] {
            if policy.canEvaluatePolicy(type) {
                policy.evaluatePolicy(with: delegate)
            } else {
                delegate.didAuthenticate(type: type, result: .failure(.invalidPolicy))
            }
        } else {
            delegate.didAuthenticate(type: type, result: .failure(.invalidPolicy))
        }
    }
}

func asyncAuthentication(completion: @escaping (Result<Bool, AuthError>) -> Void) {
    debugPrint("Authentication started...")
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
        debugPrint("Authentication completed!")
        completion(.success(true))
    }
}

var defaultPolicies: [AuthType: AuthPolicy] = [
    .location: LocationPolicy(authenticate: asyncAuthentication),
    .photo: PhotoPolicy(authenticate: asyncAuthentication),
    .video: VideoPolicy(authenticate: asyncAuthentication)
]

