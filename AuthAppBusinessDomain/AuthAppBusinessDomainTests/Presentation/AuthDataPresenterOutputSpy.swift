//
//  AuthDataPresenterOutputSpy.swift
//  AuthAppBusinessDomainTests
//
//  Created by Ashish Bhandari - TIL on 19/05/21.
//

import Foundation
import AuthAppBusinessDomain

final class AuthDataPresenterOutputSpy: AuthDataPresenterOutput {
    var results = [ResultViewModel]()
    var errors = [(type: AuthAppError, title: String, message: String)]()

    func onSuccess(model: ResultViewModel) {
        results.append(model)
    }
    
    func onFailure(error: (type: AuthAppError, title: String, message: String)) {
        errors.append(error)
    }
}
