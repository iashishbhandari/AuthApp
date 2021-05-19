//
//  AuthAppBusinessDomainIntegrationTest.swift
//  AuthAppBusinessDomainTests
//
//  Created by Ashish Bhandari - TIL on 19/05/21.
//

import XCTest
import AuthAppBusinessDomain

class AuthAppBusinessDomainIntegrationTest: XCTestCase {

    func test_AuthenticationUseCase_flow_success() {
        let output = AuthDataPresenterOutputSpy()
        let presenter = AuthenticationDataPresenter(output: output)
        var useCase = AuthenticationUseCase(service: MockAuthenticationService.success(true), output: presenter)
        XCTAssertEqual(output.results.count, 0)
        useCase.authenticate(.location)
        XCTAssertEqual(output.results.count, 1)
        XCTAssertEqual(output.results.first?.isAuthorised, true)
        XCTAssertEqual(output.results.first?.type, .location)
        useCase = AuthenticationUseCase(service: MockAuthenticationService.success(false), output: presenter)
        useCase.authenticate(.photo)
        useCase.authenticate(.video)
        XCTAssertEqual(output.results.count, 3)
        XCTAssertEqual(output.results.last?.isAuthorised, false)
        XCTAssertEqual(output.results.last?.type, .video)
    }

    func test_AuthenticationUseCase_flow_failure() {
        let output = AuthDataPresenterOutputSpy()
        let presenter = AuthenticationDataPresenter(output: output)
        var useCase = AuthenticationUseCase(service: MockAuthenticationService.failure(.serviceError), output: presenter)
        XCTAssertEqual(output.errors.count, 0)
        useCase.authenticate(.location)
        XCTAssertEqual(output.errors.count, 1)
        XCTAssertEqual(output.errors.first?.type, .serviceError)
        useCase = AuthenticationUseCase(service: MockAuthenticationService.failure(.unknown), output: presenter)
        useCase.authenticate(.photo)
        useCase.authenticate(.video)
        XCTAssertEqual(output.errors.count, 3)
        XCTAssertEqual(output.errors.last?.type, .unknown)
    }
}
