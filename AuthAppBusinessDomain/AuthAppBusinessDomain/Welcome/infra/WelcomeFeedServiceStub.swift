//  
//  Copyright (c) 2023 Ashish Bhandari
//  

import Foundation

public class WelcomeFeedServiceStub: WelcomeFeedService {
    private var items: [ListItem] = []
    
    public init(items: [ListItem]) {
        self.items = items
    }
    
    public func fetchData() async -> [ListItem] {
        items
    }
}
