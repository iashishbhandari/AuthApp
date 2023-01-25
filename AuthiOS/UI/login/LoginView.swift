//
//  Copyright (c) 2023 Ashish Bhandari
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel()
        
    var body: some View {
        VStack {
            VStack {
                TextField(AppConstants.usernamePlaceholderText, text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .padding()
                    .background(Color.green)
                SecureField(AppConstants.passwordPlaceholderText, text: $viewModel.password)
                    .padding()
                    .background(Color.green)
            }.padding()
            Button(action: {
                self.viewModel.loginAction?(.init(username: viewModel.email, password: viewModel.password))
            }) {
                Text(AppConstants.loginButtonText)
            }
            .disabled(viewModel.isCredentialEmpty)
        }
        .frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
        .ignoresSafeArea()
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
