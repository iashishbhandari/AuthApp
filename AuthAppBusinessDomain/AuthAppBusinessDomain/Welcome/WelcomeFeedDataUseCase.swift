//  
//  Copyright (c) 2023 Ashish Bhandari
//  

public protocol WelcomeFeedDataUseCaseOutput: AnyObject {
    func didComplete(result: Result<[ListItem], AuthAppError>)
}

public class WelcomeFeedDataUseCase {
    let service: WelcomeFeedService
    let output: WelcomeFeedDataUseCaseOutput
    
    public init(service: WelcomeFeedService, output: WelcomeFeedDataUseCaseOutput) {
        self.service = service
        self.output = output
    }
    
    public func getFeedData() {
        Task { [weak service, weak output] in
            if let feed = try? await service?.fetchData() {
                output?.didComplete(result: .success(feed))
            } else {
                output?.didComplete(result: .failure(.noData))
            }
        }
    }
}
