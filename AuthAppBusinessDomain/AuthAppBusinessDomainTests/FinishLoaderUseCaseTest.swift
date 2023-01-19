//
//  FinishLoaderUseCaseTest.swift
//  AuthAppBusinessLogicTests
//
//  Created by Ashish Bhandari - TIL on 16/05/21.
//

import XCTest
@testable import AuthAppBusinessDomain

class FinishLoaderUseCaseTest: XCTestCase {
    func test_complete_once_resultsCounter_one() {
        let (sut, output) = makeSUT()
        XCTAssertEqual(output.counter, 0)
        sut.complete()
        XCTAssertEqual(output.counter, 1)
    }
    
    func test_complete_twice_resultsCounter_two() {
        let (sut, output) = makeSUT()
        XCTAssertEqual(output.counter, 0)
        sut.complete()
        sut.complete()
        XCTAssertEqual(output.counter, 2)
    }
    
    // MARK: Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (FinishLoaderUseCase, FinishLoaderUseCaseOutputSpy) {
        let output = FinishLoaderUseCaseOutputSpy()
        let sut = FinishLoaderUseCase(output: output)
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, "Potential memory leak.", file: file, line: line)
        }
        return (sut, output)
    }
    
    private final class FinishLoaderUseCaseOutputSpy: FinishLoaderUseCaseOutput {
        var counter = 0
        
        func onCompleteLoading() {
            counter += 1
        }
    }
}
