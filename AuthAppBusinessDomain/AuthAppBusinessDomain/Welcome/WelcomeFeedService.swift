//  
//  Copyright (c) 2023 Ashish Bhandari
//  

import Foundation

public protocol WelcomeFeedService: AnyObject {
    func fetchData() async throws -> [ListItem]
}

public struct ListItem: Equatable, Identifiable {
    public let id: String
    public let title: String
    public let description: String
    
    public init(id: String, title: String, description: String) {
        self.id = id
        self.title = title
        self.description = description
    }
}
