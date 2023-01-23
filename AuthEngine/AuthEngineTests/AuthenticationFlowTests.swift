//
//  AuthenticationFlowTests.swift
//  AuthEngineTests
//
//  Created by Ashish Bhandari - TIL on 13/05/21.
//

import XCTest
@testable import AuthEngine

class AuthenticationFlowTests: XCTestCase {
    func test_flow_initialization_captures_no_result() {
        let (_, output) = makeSUT()
        XCTAssertEqual(output.results.count, 0)
    }

    func test_flow_started_once_captures_one_result() {
        let exp = self.expectation(description: "wait_for_credential_authentication")
        let (sut, output) = makeSUT {
            exp.fulfill()
        }
        sut.start()
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(output.results.count, 1)
    }
    
    func test_flow_started_twice_captures_two_results() {
        let exp = self.expectation(description: "wait_for_credential_authentication")
        var callCount = 0
        let (sut, output) = makeSUT {
            callCount += 1
            if callCount == 2 { exp.fulfill() }
        }
        sut.start()
        sut.start()
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(output.results.count, 2)
    }
    
    func test_flow_started_with_incorrect_credential_captures_failure() {
        let exp = self.expectation(description: "wait_for_credential_authentication")
        let wrongAuthCredential = AuthCredential(username: "username",
                                                 password: "password1")!
        let (sut, output) = makeSUT(type: .credential(wrongAuthCredential)) {
            exp.fulfill()
        }
        sut.start()
        wait(for: [exp], timeout: 1.0)
        switch output.results.first {
        case .failure(let error):
            XCTAssertEqual(error, .invalidCredential)
        default:
            assertionFailure()
        }
    }
    
    func test_flow_started_with_correct_credential_captures_success() {
        let exp = self.expectation(description: "wait_for_credential_authentication")
        let correctAuthCredential = AuthCredential(username: "username",
                                                 password: "password2")!
        let (sut, output) = makeSUT(type: .credential(correctAuthCredential)) {
            exp.fulfill()
        }
        sut.start()
        wait(for: [exp], timeout: 5.0)
        switch output.results.first {
        case .failure:
            assertionFailure()
        default:
            break
        }
    }
    
    func test_flow_started_with_valid_device_authType_captures_success() {
        let exp = self.expectation(description: "wait_for_device_authentication")
        let (sut, output) = makeSUT(type: .device(StubLAContext(.deviceOwnerAuthentication))) {
            exp.fulfill()
        }
        sut.start()
        wait(for: [exp], timeout: 1.0)
        switch output.results.first {
        case .success:
            break
        default:
            assertionFailure()
        }
    }
    
    // MARK: Helpers
    private func makeSUT(type: AuthType = .credential(dummyAuthCredential),
                         callback: (() -> Void)? = nil,
                         file: StaticString = #filePath,
                         line: UInt = #line) -> (AuthenticationFlow, AuthenticationOutputSpy) {
        let output = AuthenticationOutputSpy(callback)
        let sut = AuthenticationFlow(authType: type, authOutput: output)
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, "Potential memory leak.", file: file, line: line)
        }
        return (sut, output)
    }
    
    private static let dummyAuthCredential = AuthCredential(username: "username",
                                                       password: "password1")!
    
    private class AuthenticationOutputSpy: AuthenticationOutput {
        var callback: (() -> Void)?
        var results = [Result<AuthEngine.AuthType, AuthEngine.AuthError>]()
        
        init(_ callback: (() -> Void)? = nil) {
            self.callback = callback
        }
        
        func didAuthenticate(result: Result<AuthEngine.AuthType, AuthEngine.AuthError>) {
            results.append(result)
            callback?()
        }
    }
}
