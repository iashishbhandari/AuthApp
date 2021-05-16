//
//  AuthContextIntegrationTest.swift
//  AuthEngineTests
//
//  Created by Ashish Bhandari - TIL on 13/05/21.
//

import XCTest
import AuthEngine

class AuthContextIntegrationTest: XCTestCase {
    var authContext: AuthContext<DelegateSpy>!
    
    func test_locationContext_authenticateOnce_resultsSuccessCount_one() {
        let exp = self.expectation(description: "LocationAuthContext")
        let delegate = DelegateSpy {
            exp.fulfill()
        }
        XCTAssertEqual(delegate.results.count, 0)
        authContext = AuthContext.authenticate(for: .location, delegate: delegate)
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(delegate.results.count, 1)
        XCTAssertEqual(delegate.results.first, .success(true))
    }
    
    func test_locationContext_authenticateTwice_resultsSuccessCount_two() {
        let exp = self.expectation(description: "LocationAuthContext")
        var callBackCounter = 0
        let delegate = DelegateSpy {
            callBackCounter += 1
            if callBackCounter == 2 {
                exp.fulfill()
            }
        }
        XCTAssertEqual(delegate.results.count, 0)
        authContext = AuthContext.authenticate(for: .location, delegate: delegate)
        authContext = AuthContext.authenticate(for: .location, delegate: delegate)
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(delegate.results.count, 2)
        XCTAssertEqual(delegate.results.first, .success(true))
        XCTAssertEqual(delegate.results.last, .success(true))
    }
    
    func test_photoContext_authenticateOnce_resultsSuccessCount_one() {
        let exp = self.expectation(description: "PhotoAuthContext")
        let delegate = DelegateSpy {
            exp.fulfill()
        }
        XCTAssertEqual(delegate.results.count, 0)
        authContext = AuthContext.authenticate(for: .photo, delegate: delegate)
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(delegate.results.count, 1)
        XCTAssertEqual(delegate.results.first, .success(true))
    }
    
    func test_photoContext_authenticateTwice_resultsSuccessCount_two() {
        let exp = self.expectation(description: "PhotoAuthContext")
        var callBackCounter = 0
        let delegate = DelegateSpy {
            callBackCounter += 1
            if callBackCounter == 2 {
                exp.fulfill()
            }
        }
        XCTAssertEqual(delegate.results.count, 0)
        authContext = AuthContext.authenticate(for: .photo, delegate: delegate)
        authContext = AuthContext.authenticate(for: .photo, delegate: delegate)
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(delegate.results.count, 2)
        XCTAssertEqual(delegate.results.first, .success(true))
        XCTAssertEqual(delegate.results.last, .success(true))
    }
    
    func test_videoContext_authenticateOnce_resultsSuccessCount_one() {
        let exp = self.expectation(description: "VideoAuthContext")
        let delegate = DelegateSpy {
            exp.fulfill()
        }
        XCTAssertEqual(delegate.results.count, 0)
        authContext = AuthContext.authenticate(for: .video, delegate: delegate)
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(delegate.results.count, 1)
        XCTAssertEqual(delegate.results.first, .success(true))
    }
    
    func test_videoContext_authenticateTwice_resultsSuccessCount_two() {
        let exp = self.expectation(description: "VideoAuthContext")
        var callBackCounter = 0
        let delegate = DelegateSpy {
            callBackCounter += 1
            if callBackCounter == 2 {
                exp.fulfill()
            }
        }
        XCTAssertEqual(delegate.results.count, 0)
        authContext = AuthContext.authenticate(for: .video, delegate: delegate)
        authContext = AuthContext.authenticate(for: .video, delegate: delegate)
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(delegate.results.count, 2)
        XCTAssertEqual(delegate.results.first, .success(true))
        XCTAssertEqual(delegate.results.last, .success(true))
    }
}

