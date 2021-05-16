//
//  LoaderViewModel.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 16/05/21.
//

import SwiftUI

final class LoaderViewModel: ObservableObject {
    @Published var isAnimating = false
    
    var handler: (() -> Void)?

    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
}
