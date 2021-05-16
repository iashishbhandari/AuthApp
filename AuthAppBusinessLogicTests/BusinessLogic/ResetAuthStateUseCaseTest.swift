//
//  ResetAuthStateUseCaseTest.swift
//  AuthAppBusinessLogicTests
//
//  Created by Ashish Bhandari - TIL on 16/05/21.
//

import XCTest
@testable import AuthAppBusinessLogic

class ResetAuthStateUseCaseTest: XCTestCase {

    func test_reset_once_sets_counter_one() {
        let output = ResetAuthStateUseCaseSpy()
        let sut = ResetAuthStateUseCase(output: output)
        XCTAssertEqual(output.counter, 0)
        sut.reset()
        XCTAssertEqual(output.counter, 1)
    }
    
    func test_reset_twice_sets_counter_two() {
        let output = ResetAuthStateUseCaseSpy()
        let sut = ResetAuthStateUseCase(output: output)
        XCTAssertEqual(output.counter, 0)
        sut.reset()
        sut.reset()
        XCTAssertEqual(output.counter, 2)
    }

}

private final class ResetAuthStateUseCaseSpy: ResetAuthStateUseCaseOutput {
    var counter = 0
    
    func onResetAuthState() {
        counter += 1
    }
}
