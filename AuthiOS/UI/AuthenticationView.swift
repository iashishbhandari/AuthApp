//
//  AuthenticationView.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 14/05/21.
//

import AuthAppBusinessDomain
import SwiftUI

struct AuthenticationView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject var viewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            Spacer()
            if horizontalSizeClass == .compact {
                VStack {
                    GroupButtonsView(viewModel: viewModel)
                }
            } else {
                HStack {
                    GroupButtonsView(viewModel: viewModel)
                }
            }
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

struct GroupButtonsView: View {
    @ObservedObject var viewModel: AuthenticationViewModel

    var body: some View {
        Group {
            if viewModel.isAuthorised {
                ButtonView(buttonType: .login, action: viewModel.handler)
            } else {
                ButtonView(buttonType: .unlock, action: viewModel.handler)
            }
        }
        .disabled(viewModel.isAuthorised)
        .padding()
    }
}

struct ButtonView: View {
    let buttonType: AuthAppButtonType
    let action: ((AuthAppButtonType) -> Void)?

    var body: some View {
        Button(buttonType.rawValue) {
            action?(buttonType)
        }
        .padding()
        .background(Color.red)
        .foregroundColor(Color.white)
        .clipShape(Capsule())
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(viewModel: AuthenticationViewModel())
    }
}
