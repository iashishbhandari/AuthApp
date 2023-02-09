//  
//  Copyright (c) 2023 Ashish Bhandari
//  

import AuthAppBusinessDomain
import Foundation

class WelcomeViewModel: ObservableObject {
    @Published var items: [ListItem] = []
        
    var getFeedData: (() -> Void)?
}

extension WelcomeViewModel: WelcomeFeedDataUseCaseOutput {
    func didComplete(result: Result<[ListItem], AuthAppError>) {
        switch result {
        case .success(let items):
            self.items = items
        case .failure:
            break
        }
    }
}
