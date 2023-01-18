//
//  AuthenticationFlowTests.swift
//  AuthEngineTests
//
//  Created by Ashish Bhandari - TIL on 13/05/21.
//

import LocalAuthentication
import XCTest
@testable import AuthEngine

class AuthenticationFlowTests: XCTestCase {
    private weak var weakSUT: AuthenticationFlow?
    
    override func tearDown() {
        super.tearDown()
        XCTAssertNil(weakSUT)
    }
    
    func test_flow_initialization_output_captures_none() {
        let (_, output) = makeSUT()
        XCTAssertEqual(output.results.count, 0)
    }

    func test_flow_started_once_output_captures_once() {
        let (sut, output) = makeSUT()
        sut.start()
        XCTAssertEqual(output.results.count, 1)
    }
    
    func test_flow_started_twice_output_captures_twice() {
        let (sut, output) = makeSUT()
        sut.start()
        sut.start()
        XCTAssertEqual(output.results.count, 2)
    }
    
    func test_flow_started_for_remote_authType_fails() {
        let exp = self.expectation(description: "test_flow_started_for_remote_authType_fails")
        let (sut, output) = makeSUT() {
            exp.fulfill()
        }
        sut.start()
        wait(for: [exp], timeout: 1.0)
        switch output.results.first {
        case .failure(let error):
            XCTAssertEqual(error, .invalidSource)
        default:
            assertionFailure()
        }
    }
    
    func test_flow_started_for_device_authType_passes() {
        let exp = self.expectation(description: "test_flow_started_for_local_authType_passes")
        let (sut, output) = makeSUT(type: .device(StubLAContext())) {
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
    private func makeSUT(type: AuthType = .remote, callback: (() -> Void)? = nil) -> (AuthenticationFlow, AuthenticationOutputSpy) {
        let output = AuthenticationOutputSpy(callback)
        let sut = AuthenticationFlow(authType: type, authOutput: output)
        weakSUT = sut
        return (sut, output)
    }
    
    private class AuthenticationOutputSpy: AuthenticationOutput {
        var callback: (() -> Void)?
        var results = [Result<Void, AuthEngine.AuthError>]()
        
        init(_ callback: (() -> Void)? = nil) {
            self.callback = callback
        }
        
        func didAuthenticate(type: AuthEngine.AuthType, result: Result<Void, AuthEngine.AuthError>) {
            results.append(result)
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
}
