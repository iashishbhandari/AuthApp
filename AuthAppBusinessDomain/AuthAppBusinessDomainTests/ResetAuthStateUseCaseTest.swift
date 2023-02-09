//
//  Copyright (c) 2023 Ashish Bhandari
//

import AuthAppBusinessDomain
import XCTest

class ResetAuthStateUseCaseTest: XCTestCase {
    func test_reset_once_sets_counter_one() {
        let (sut, output) = makeSUT()
        XCTAssertEqual(output.counter, 0)
        sut.reset()
        XCTAssertEqual(output.counter, 1)
    }
    
    func test_reset_twice_sets_counter_two() {
        let (sut, output) = makeSUT()
        XCTAssertEqual(output.counter, 0)
        sut.reset()
        sut.reset()
        XCTAssertEqual(output.counter, 2)
    }
    
    // MARK: Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (ResetAuthStateUseCase, ResetAuthStateUseCaseSpy) {
        let output = ResetAuthStateUseCaseSpy()
        let sut = ResetAuthStateUseCase(output: output)
        trackMemoryLeak(of: sut)
        trackMemoryLeak(of: output)
        return (sut, output)
    }

    private final class ResetAuthStateUseCaseSpy: ResetAuthStateUseCaseOutput {
        var counter = 0
        
        func onResetAuthState() {
            counter += 1
        }
    }
}
