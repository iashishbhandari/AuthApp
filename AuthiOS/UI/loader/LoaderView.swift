//
//  Copyright (c) 2023 Ashish Bhandari
//

import SwiftUI

struct LoaderView: View {
    @ObservedObject var viewModel: LoaderViewModel
    
    var body: some View {
        VStack {
            Image(systemName: AppConstants.loadingIcon)
                .resizable()
                .frame(width: 40, height: 50, alignment: .center)
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: viewModel.isAnimating ? 360 : 0.0))
                .animation(viewModel.isAnimating ? viewModel.foreverAnimation : .default)
                .onAppear { viewModel.isAnimating = true }
                .onDisappear { viewModel.isAnimating = false }
            Text(AppConstants.loadingText)
                .font(.title2)
                .foregroundColor(.white)
                .padding()
        }
        .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 100, maxHeight: .infinity, alignment: .center)
        .background(Color.blue)
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
                viewModel.handler?()
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView(viewModel: LoaderViewModel())
    }
}
