//
//  AuthenticationUseCaseTest.swift
//  AuthAppBusinessLogicTests
//
//  Created by Ashish Bhandari - TIL on 16/05/21.
//

import LocalAuthentication
import XCTest
@testable import AuthAppBusinessDomain

class AuthenticationUseCaseTest: XCTestCase {
    func test_authenticate_once_resultsCount_one_withCorrectData() {
        let exp = self.expectation(description: "test_authenticate_once_resultsCount_one_withCorrectData")
        let output = AuthenticationUseCaseOutputSpy {
            exp.fulfill()
        }
        let sut = AuthenticationUseCase(authContext: StubLAContext(), output: output)
        XCTAssertEqual(output.results.count, 0)
        sut.authenticate(.unlock)
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(output.results.count, 1)
        XCTAssertEqual(output.results.first!.type, .unlock)
        switch output.results.first!.result {
        case .failure(_):
            assertionFailure()
        default:
            break
        }
    }
    
    func test_authenticate_twice_resultsCount_two_withCorrectData() {
        let exp1 = self.expectation(description: "wait_for_unlock_authentication")
        let output = AuthenticationUseCaseOutputSpy {
            exp1.fulfill()
        }
        var sut = AuthenticationUseCase(authContext: StubLAContext(), output: output)
        XCTAssertEqual(output.results.count, 0)
        sut.authenticate(.unlock)
        wait(for: [exp1], timeout: 1.0)
        XCTAssertEqual(output.results.count, 1)
        XCTAssertEqual(output.results.first!.type, .unlock)
        switch output.results.first!.result {
        case .failure(_):
            assertionFailure()
        default:
            break
        }
        
        let exp2 = self.expectation(description: "wait_for_login_authentication")
        let output2 = AuthenticationUseCaseOutputSpy {
            exp2.fulfill()
        }
        sut = AuthenticationUseCase(output: output2)
        sut.authenticate(.login)
        wait(for: [exp2], timeout: 1.0)
        XCTAssertEqual(output2.results.last!.type, .login)
        switch output2.results.last!.result {
        case .failure:
            break
        case .success:
            assertionFailure()
        }
    }
}

private final class AuthenticationUseCaseOutputSpy: AuthenticationUseCaseOutput {
    var callback: (() -> Void)?
    var results = [(type: AuthAppButtonType, result: Result<AuthAppModel, AuthAppError>)]()

    init(_ callback: (() -> Void)? = nil) {
        self.callback = callback
    }
    
    func didComplete(for type: AuthAppButtonType, result: Result<AuthAppModel, AuthAppError>) {
        results.append((type: type, result: result))
        callback?()
    }
}

private class StubLAContext: LAContext {
    override func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
        true
    }
    
    override func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void) {
        reply(true, nil)
    }
}
