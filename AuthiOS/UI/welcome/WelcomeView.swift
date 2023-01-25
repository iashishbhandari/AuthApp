//
//  Copyright (c) 2023 Ashish Bhandari
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        Text(AppConstants.welcomeBackText)
            .font(.title)
            .bold()
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
