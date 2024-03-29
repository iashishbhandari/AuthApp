//
//  Copyright (c) 2023 Ashish Bhandari
//

import AuthAppBusinessDomain
import XCTest

class FinishLoaderUseCaseTest: XCTestCase {
    func test_complete_once_resultsCounter_one() {
        var counter = 0
        let sut = makeSUT(output: { counter += 1 })
        XCTAssertEqual(counter, 0)
        sut.complete()
        XCTAssertEqual(counter, 1)
    }
    
    func test_complete_twice_resultsCounter_two() {
        var counter = 0
        let sut = makeSUT(output: { counter += 1 })
        XCTAssertEqual(counter, 0)
        sut.complete()
        sut.complete()
        XCTAssertEqual(counter, 2)
    }
    
    // MARK: Helpers
    private func makeSUT(output: @escaping FinishLoaderUseCaseOutput,
                         file: StaticString = #filePath, line: UInt = #line) -> FinishLoaderUseCase {
        let sut = FinishLoaderUseCase(output: output)
        trackMemoryLeak(of: sut)
        return sut
    }
}
