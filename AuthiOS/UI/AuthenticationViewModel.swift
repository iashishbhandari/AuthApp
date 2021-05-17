//
//  AuthenticationViewModel.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 15/05/21.
//

import SwiftUI
import AuthAppBusinessDomain

final class AuthenticationViewModel: ObservableObject {
    @Published var alertInfo: (title: String, message: String, buttonText: String, isPresented: Bool) = AppConstants.alertInfo
    @Published var resultViewModel: ResultViewModel = ResultViewModel()
    
    var handler: ((AuthAppButtonType) -> Void)?
    var resetAction: (() -> Void)?

    var isAuthorised: Bool {
        resultViewModel.isAuthorised
    }
    
    func isSelected(type: AuthAppButtonType) -> Bool {
        resultViewModel.type == type
    }
}

extension AuthenticationViewModel: AuthDataPresenterOutput {
    func onSuccess(model: ResultViewModel) {
        resultViewModel = model
    }
    
    func onFailure(error: (type: AuthAppError, title: String, message: String)) {
        alertInfo = (error.title, error.message, "Ok", true)
    }
}
