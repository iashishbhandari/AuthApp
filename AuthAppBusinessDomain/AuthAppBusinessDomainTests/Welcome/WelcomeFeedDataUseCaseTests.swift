//  
//  Copyright (c) 2023 Ashish Bhandari
//  

import AuthAppBusinessDomain
import XCTest

final class WelcomeFeedDataUseCaseTests: XCTestCase {
    func testEmptyFeed() {
        let exp = XCTestExpectation(description: "wait for EmptyFeed")
        let (sut, output) = makeSUT(items: []) {
            exp.fulfill()
        }
        sut.getFeedData()
        wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(output.results.first, [])
    }
    
    func testNonEmptyFeed() {
        let exp = XCTestExpectation(description: "wait for NonEmptyFeed")
        let items: [ListItem] = [
            .init(id: UUID().uuidString,
                  title: "a title",
                  description: "a description"),
            .init(id: UUID().uuidString,
                  title: "another title",
                  description: "a \n multiline \n description")
        ]
        let (sut, output) = makeSUT(items: items) {
            exp.fulfill()
        }
        sut.getFeedData()
        wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(output.results.first, items)
    }
    
    // MARK: Helpers
    private func makeSUT(items: [ListItem],
                         callback: (() -> Void)?,
                         file: StaticString = #filePath,
                         line: UInt = #line) -> (WelcomeFeedDataUseCase, WelcomeFeedDataUseCaseOutputSpy) {
        let output = WelcomeFeedDataUseCaseOutputSpy(callback)
        let sut = WelcomeFeedDataUseCase(service: WelcomeFeedServiceStub(items: items), output: output)
        trackMemoryLeak(of: sut)
        trackMemoryLeak(of: output)
        return (sut, output)
    }
    
    private class WelcomeFeedDataUseCaseOutputSpy: WelcomeFeedDataUseCaseOutput {
        private let callback: (() -> Void)?
        private(set) var results: [[ListItem]] = []
        
        init(_ callback: (() -> Void)?) {
            self.callback = callback
        }
        
        func didComplete(result: Result<[ListItem], AuthAppError>) {
            switch result {
            case .success(let items):
                results.append(items)
            case .failure:
                break
            }
            callback?()
        }
    }
}
