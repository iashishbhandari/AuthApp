//
//  Copyright (c) 2023 Ashish Bhandari
//

import AuthAppBusinessDomain
import SwiftUI

final class LockedViewModel: ObservableObject {
    let isAuthorised: Bool
    
    init(isAuthorised: Bool) {
        self.isAuthorised = isAuthorised
    }
    
    var handler: (() -> Void)?
    var resetAction: (() -> Void)?

    var imageName: String {
        isAuthorised ? AppConstants.unlockIcon : AppConstants.lockIcon
    }
    
    var authStatusText: String {
        isAuthorised ? AppConstants.authorisedText : AppConstants.unauthorisedText
    }
}
