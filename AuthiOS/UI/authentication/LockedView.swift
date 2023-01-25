//
//  Copyright (c) 2023 Ashish Bhandari
//

import AuthAppBusinessDomain
import SwiftUI

struct LockedView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject var viewModel: LockedViewModel

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
            LockedStatusView(viewModel: viewModel)
            if viewModel.isAuthorised {
                Spacer()
                ResetButtonView {
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
    }
}

struct GroupButtonsView: View {
    @ObservedObject var viewModel: LockedViewModel
    
    var body: some View {
        Group {
            if viewModel.isAuthorised {
                ButtonView(buttonType: .signIn, buttonAction: viewModel.handler)
            } else {
                ButtonView(buttonType: .unlock, buttonAction: viewModel.handler)
            }
        }
        .padding()
    }
}

struct ButtonView: View {
    enum ButtonType {
        case unlock
        case signIn
    }
    let buttonType: ButtonType
    let buttonAction: (() -> Void)?

    var body: some View {
        Button(getTitle(buttonType)) {
            buttonAction?()
        }
        .padding()
        .background(Color.red)
        .foregroundColor(Color.white)
        .clipShape(Capsule())
    }
    
    private func getTitle(_ buttonType: ButtonType) -> String {
        var title: String
        switch buttonType {
        case .unlock:
            title = AppConstants.unlockButtonText
        case .signIn:
            title = AppConstants.signInButtonText
        }
        return title
    }
}

struct LockedStatusView: View {
    let viewModel: LockedViewModel
    
    var body: some View {
        HStack {
            Image(systemName: viewModel.imageName)
                .resizable()
                .frame(width: 30, height: viewModel.isAuthorised ? 30 : 35, alignment: .center)
                .padding(.top, 15)
            Text(viewModel.authStatusText)
                .font(.body)
                .padding(.top, 20)
                .padding()
                .foregroundColor(.yellow)
        }
    }
}

struct ResetButtonView: View {
    let action: (() -> Void)?

    var body: some View {
        Button(AppConstants.resetButtonText) {
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
        LockedView(viewModel: LockedViewModel(isAuthorised: false))
    }
}
