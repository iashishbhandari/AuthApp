//
//  Copyright (c) 2023 Ashish Bhandari
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
