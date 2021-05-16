//
//  AuthenticationView.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 14/05/21.
//

import SwiftUI
import AuthEngine
import AuthAppBusinessLogic

struct AuthenticationView: View {
    @ObservedObject var viewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            Spacer()
            HStack {
                ButtonView(buttonType: .location, action: viewModel.handler, isSelected: viewModel.isSelected(type: .location))
                ButtonView(buttonType: .photo, action: viewModel.handler, isSelected: viewModel.isSelected(type: .photo))
                ButtonView(buttonType: .video, action: viewModel.handler, isSelected: viewModel.isSelected(type: .video))
            }
            .disabled(viewModel.isAuthorised)
            .padding()
            ResultView(viewModel: $viewModel.resultViewModel)
            if viewModel.isAuthorised {
                Spacer()
                ResetView {
                    viewModel.resetAction?()
                }
                .padding(.bottom, 64)
            } else {
                Spacer()
            }
        }
        .frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
        .background(Color.blue)
        .ignoresSafeArea()
        .alert(isPresented: $viewModel.alertInfo.isPresented) { () -> Alert in
            Alert(title: Text(viewModel.alertInfo.title), message: Text(viewModel.alertInfo.message), dismissButton: .default(Text("Ok")))
        }
    }
}

struct ButtonView: View {
    let buttonType: ButtonType
    let action: ((AuthType) -> Void)?
    var isSelected: Bool

    var body: some View {
        Button(buttonType.rawValue) {
            action?(getAuthType(for: buttonType))
        }
        .padding()
        .background(isSelected ? Color.red : Color.black)
        .foregroundColor(Color.white)
        .clipShape(Capsule())
    }
    
    private func getAuthType(for buttonType: ButtonType) -> AuthType {
        switch buttonType {
        case .location:
            return .location
        case .photo:
            return .photo
        case .video:
            return .video
        }
    }
}

struct ResultView: View {
    @Binding var viewModel: ResultViewModel
    
    var body: some View {
        HStack {
            Image(systemName: viewModel.imageName)
                .resizable()
                .frame(width: 30, height: viewModel.isAuthorised ? 30 : 35, alignment: .center)
                .padding(.top, 15)
            Text(viewModel.resultText)
                .font(.body)
                .padding(.top, 20)
                .padding()
                .foregroundColor(.yellow)
        }
    }
}

struct ResetView: View {
    let action: (() -> Void)?

    var body: some View {
        Button("RESET") {
            action?()
        }
        .padding()
        .background(Color.black)
        .foregroundColor(Color.white)
        .clipShape(Capsule())
    }
}

enum ButtonType: String {
    case location = "Location"
    case photo = "Photos"
    case video = "Videos"
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(viewModel: AuthenticationViewModel())
    }
}
