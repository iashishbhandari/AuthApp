//
//  AuthenticationUseCaseTest.swift
//  AuthAppBusinessLogicTests
//
//  Created by Ashish Bhandari - TIL on 16/05/21.
//

import XCTest
@testable import AuthAppBusinessDomain

class AuthenticationUseCaseTest: XCTestCase {
    func test_device_authentication_unlocks_successfully() {
        let (sut, output) = makeSUT()
        XCTAssertEqual(output.results.count, 0)
        sut.didAuthenticate(type: .device(), result: .success(()))
        XCTAssertEqual(output.results.count, 1)
        switch output.results.first! {
        case .failure:
            assertionFailure()
        case .success:
            break
        }
    }
    
    func test_device_unlock_followed_by_invalid_remote_authentication_fails_to_login() {
        let (sut, output) = makeSUT()
        XCTAssertEqual(output.results.count, 0)
        sut.didAuthenticate(type: .device(), result: .success(()))
        sut.didAuthenticate(type: .remote, result: .failure(.invalidCredential))
        XCTAssertEqual(output.results.count, 2)
        switch (output.results.first!, output.results.last!) {
        case (.success, .failure(let error)):
            XCTAssertEqual(error, .invalidCredentials)
        default:
            assertionFailure()
        }
    }
    
    // MARK: Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (AuthenticationUseCase, AuthenticationUseCaseOutputSpy) {
        let output = AuthenticationUseCaseOutputSpy()
        let sut = AuthenticationUseCase(output: output)
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, "Potential memory leak.", file: file, line: line)
        }
        return (sut, output)
    }
    
    private final class AuthenticationUseCaseOutputSpy: AuthenticationUseCaseOutput {
        var results = [Result<AuthAppModel, AuthAppError>]()

        func didComplete(result: Result<AuthAppModel, AuthAppError>) {
            results.append(result)
        }
    }
}
