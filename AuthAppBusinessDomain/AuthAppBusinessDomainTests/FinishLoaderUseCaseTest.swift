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
        let output = FinishLoaderUseCaseOutputSpy()
        let sut = FinishLoaderUseCase(output: output)
        XCTAssertEqual(output.counter, 0)
        sut.complete()
        XCTAssertEqual(output.counter, 1)
    }
    
    func test_complete_twice_resultsCounter_two() {
        let output = FinishLoaderUseCaseOutputSpy()
        let sut = FinishLoaderUseCase(output: output)
        XCTAssertEqual(output.counter, 0)
        sut.complete()
        sut.complete()
        XCTAssertEqual(output.counter, 2)
    }
}

private final class FinishLoaderUseCaseOutputSpy: FinishLoaderUseCaseOutput {
    var counter = 0
    
    func onCompleteLoading() {
        counter += 1
    }
}
