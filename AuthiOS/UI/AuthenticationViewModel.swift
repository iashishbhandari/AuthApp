//
//  AuthenticationViewModel.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 15/05/21.
//

import AuthAppBusinessDomain
import SwiftUI

final class AuthenticationViewModel: ObservableObject {
    @Published var alertInfo: (title: String, message: String, buttonText: String, isPresented: Bool) = AppConstants.alertInfo
    @Published var resultViewModel: ResultViewModel = ResultViewModel()
    
    var handler: ((AuthAppButtonType) -> Void)?
    var resetAction: (() -> Void)?

    var isAuthorised: Bool {
        resultViewModel.isAuthorised
    }
}

extension AuthenticationViewModel: AuthDataPresenterOutput {
    func onSuccess(model: ResultViewModel) {
        runOnMainThread {
            self.resultViewModel = model
        }
    }
    
    func onFailure(error: (type: AuthAppError, title: String, message: String)) {
        runOnMainThread {
            self.alertInfo = (error.title, error.message, "Ok", true)
        }
    }
    
    private func runOnMainThread(execute: @escaping () -> Void) {
        if Thread.isMainThread {
            execute()
        } else {
            DispatchQueue.main.async { execute() }
        }
    }
}
