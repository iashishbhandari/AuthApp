//
//  AuthenticationUseCaseTest.swift
//  AuthAppBusinessLogicTests
//
//  Created by Ashish Bhandari - TIL on 16/05/21.
//

import XCTest
@testable import AuthAppBusinessDomain

class AuthenticationUseCaseTest: XCTestCase {

    func test_authenticate_once_resultsCount_one_withCorrectData() {
        let output = AuthenticationUseCaseOutputSpy()
        let sut = AuthenticationUseCase(service: MockAuthenticationService.success(true), output: output)
        XCTAssertEqual(output.results.count, 0)
        sut.authenticate(.location)
        XCTAssertEqual(output.results.count, 1)
        XCTAssertEqual(output.results.first!.type, .location)
        XCTAssertEqual(output.results.first!.result, .success(true))
    }
    
    func test_authenticate_twice_resultsCount_two_withCorrectData() {
        let output = AuthenticationUseCaseOutputSpy()
        var sut = AuthenticationUseCase(service: MockAuthenticationService.success(false), output: output)
        XCTAssertEqual(output.results.count, 0)
        sut.authenticate(.location)
        sut = AuthenticationUseCase(service: MockAuthenticationService.failure(.serviceError), output: output)
        sut.authenticate(.photo)
        XCTAssertEqual(output.results.count, 2)
        XCTAssertEqual(output.results.first!.type, .location)
        XCTAssertEqual(output.results.first!.result, .success(false))
        XCTAssertEqual(output.results.last!.type, .photo)
        XCTAssertEqual(output.results.last!.result, .failure(.serviceError))
    }
}

private final class AuthenticationUseCaseOutputSpy: AuthenticationUseCaseOutput {
    var results = [(type: AuthAppButtonType, result: Result<Bool, AuthAppError>)]()
    
    func didComplete(for type: AuthAppButtonType, result: Result<Bool, AuthAppError>) {
        results.append((type: type, result: result))
    }
}
