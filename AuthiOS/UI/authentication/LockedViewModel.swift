//
//  Copyright (c) 2023 Ashish Bhandari
//

import AuthAppBusinessDomain
import SwiftUI

final class LockedViewModel: ObservableObject {
    @Published var authModel: AuthAppModel?
    
    var handler: (() -> Void)?
    var resetAction: (() -> Void)?

    var isAuthorised: Bool {
        !(authModel?.token.isEmpty ?? true)
    }
    
    var imageName: String {
        isAuthorised ? AppConstants.unlockIcon : AppConstants.lockIcon
    }
    
    var authStatusText: String {
        isAuthorised ? AppConstants.authorisedText : AppConstants.unauthorisedText
    }
}
