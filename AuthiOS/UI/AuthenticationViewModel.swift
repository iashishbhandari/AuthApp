//
//  AuthenticationViewModel.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 15/05/21.
//

import SwiftUI
import AuthEngine
import AuthAppBusinessLogic

final class AuthenticationViewModel: ObservableObject {
    @Published var alertInfo: (title: String, message: String, buttonText: String, isPresented: Bool) = AppConstants.alertInfo
    @Published var resultViewModel: ResultViewModel = ResultViewModel(isAuthorised: false, type: nil)
    
    var handler: ((AuthType) -> Void)?
    var resetAction: (() -> Void)?

    var isAuthorised: Bool {
        resultViewModel.isAuthorised
    }
    
    func isSelected(type: ButtonType) -> Bool {
        switch type {
        case .location:
            return resultViewModel.type == AuthType.location
        case .photo:
            return resultViewModel.type == AuthType.photo
        case .video:
            return resultViewModel.type == AuthType.video
        }
    }
}

extension AuthenticationViewModel: AuthDataPresenterOutput {
    func onSuccess(model: ResultViewModel) {
        resultViewModel = model
    }
    
    func onFailure(error: (type: AuthError, title: String, message: String)) {
        alertInfo = (error.title, error.message, "Ok", true)
    }
}
