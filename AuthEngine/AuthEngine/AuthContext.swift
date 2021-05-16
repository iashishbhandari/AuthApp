//
//  AuthContext.swift
//  AuthEngine
//
//  Created by Ashish Bhandari - TIL on 13/05/21.
//

import Foundation

public final class AuthContext<Delegate: AuthDelegate> {
    private let flow: AuthFlow<Delegate>
    
    private init(flow: AuthFlow<Delegate>) {
        self.flow = flow
    }
    
    public static func authenticate(for type: AuthType, delegate: Delegate) -> AuthContext<Delegate> {
        let flow = AuthFlow<Delegate>(type, delegate)
        flow.start()
        return AuthContext(flow: flow)
    }
}
