//  
//  Copyright (c) 2023 Ashish Bhandari
//  

import AuthAppBusinessDomain
import XCTest

final class WelcomeFeedServiceStubTests: XCTestCase {
    func test_stub_zeroItems_fetchData_returns_zeroItems() async {
        let sut = makeSUT(items: [])
        let feed = await sut.fetchData()
        XCTAssertEqual(feed, [])
    }
    
    func test_stub_nonZeroItems_fetchData_returns_nonZeroItems() async {
        let items: [ListItem] = [
            .init(id: UUID().uuidString,
                  title: "a title",
                  description: "a description"),
            .init(id: UUID().uuidString,
                  title: "another title",
                  description: "a \n multiline \n description")
        ]
        let sut = makeSUT(items: items)
        let feed = await sut.fetchData()
        XCTAssertEqual(feed, items)
    }
    
    // MARK: Helpers
    private func makeSUT(items: [ListItem],
                         file: StaticString = #filePath,
                         line: UInt = #line) -> WelcomeFeedServiceStub {
        let sut = WelcomeFeedServiceStub(items: items)
        trackMemoryLeak(of: sut)
        return sut
    }
}
