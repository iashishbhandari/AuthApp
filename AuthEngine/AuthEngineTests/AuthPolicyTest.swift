//
//  AuthPolicyTest.swift
//  AuthEngineTests
//
//  Created by Ashish Bhandari - TIL on 15/05/21.
//

import XCTest
@testable import AuthEngine

class LocationPolicyTest: XCTestCase {

    func test_locationType_canEvaluatePolicy() {
        let sut = makeSUT()
        XCTAssertTrue(sut.canEvaluatePolicy(.location))
    }
    
    func test_photoType_cannotEvaluatePolicy() {
        let sut = makeSUT()
        XCTAssertFalse(sut.canEvaluatePolicy(.photo))
    }

    func test_videoType_cannotEvaluatePolicy() {
        let sut = makeSUT()
        XCTAssertFalse(sut.canEvaluatePolicy(.video))
    }
    
    func test_evaluatePolicy_success() {
        let sut = makeSUT(success: true)
        let delegate = DelegateSpy()
        sut.evaluatePolicy(with: delegate)
        XCTAssertEqual(delegate.results.count, 1)
        XCTAssertEqual(delegate.results.first, .success(true))
    }
    
    func test_evaluatePolicy_failure() {
        let sut = makeSUT(success: false)
        let delegate = DelegateSpy()
        sut.evaluatePolicy(with: delegate)
        XCTAssertEqual(delegate.results.count, 1)
        XCTAssertEqual(delegate.results.first, .success(false))
    }
    
    //MARK: Helpers
    private func makeSUT(success: Bool = true) -> LocationPolicy {
        let sut = LocationPolicy(authenticate: success ? syncAuthentication(_:) : syncAuthenticationFailure(_:))
        return sut
    }
}

class PhotoPolicyTest: XCTestCase {
    
    func test_photoType_canEvaluatePolicy() {
        let sut = makeSUT()
        XCTAssertTrue(sut.canEvaluatePolicy(.photo))
    }
    
    func test_locationType_cannotEvaluatePolicy() {
        let sut = makeSUT()
        XCTAssertFalse(sut.canEvaluatePolicy(.location))
    }

    func test_videoType_cannotEvaluatePolicy() {
        let sut = makeSUT()
        XCTAssertFalse(sut.canEvaluatePolicy(.video))
    }
    
    func test_evaluatePolicy_success() {
        let sut = makeSUT(success: true)
        let delegate = DelegateSpy()
        sut.evaluatePolicy(with: delegate)
        XCTAssertEqual(delegate.results.count, 1)
        XCTAssertEqual(delegate.results.first, .success(true))
    }
    
    func test_evaluatePolicy_failure() {
        let sut = makeSUT(success: false)
        let delegate = DelegateSpy()
        sut.evaluatePolicy(with: delegate)
        XCTAssertEqual(delegate.results.count, 1)
        XCTAssertEqual(delegate.results.first, .success(false))
    }
    
    //MARK: Helpers
    private func makeSUT(success: Bool = true) -> PhotoPolicy {
        let sut = PhotoPolicy(authenticate: success ? syncAuthentication(_:) : syncAuthenticationFailure(_:))
        return sut
    }
}

class VideoPolicyTest: XCTestCase {
    
    func test_videoType_canEvaluatePolicy() {
        let sut = makeSUT()
        XCTAssertTrue(sut.canEvaluatePolicy(.video))
    }
    
    func test_photoType_cannotEvaluatePolicy() {
        let sut = makeSUT()
        XCTAssertFalse(sut.canEvaluatePolicy(.photo))
    }
    
    func test_locationType_cannotEvaluatePolicy() {
        let sut = makeSUT()
        XCTAssertFalse(sut.canEvaluatePolicy(.location))
    }
    
    func test_evaluatePolicy_success() {
        let sut = makeSUT(success: true)
        let delegate = DelegateSpy()
        sut.evaluatePolicy(with: delegate)
        XCTAssertEqual(delegate.results.count, 1)
        XCTAssertEqual(delegate.results.first, .success(true))
    }
    
    func test_evaluatePolicy_failure() {
        let sut = makeSUT(success: false)
        let delegate = DelegateSpy()
        sut.evaluatePolicy(with: delegate)
        XCTAssertEqual(delegate.results.count, 1)
        XCTAssertEqual(delegate.results.first, .success(false))
    }
    
    //MARK: Helpers
    private func makeSUT(success: Bool = true) -> VideoPolicy {
        let sut = VideoPolicy(authenticate: success ? syncAuthentication(_:) : syncAuthenticationFailure(_:))
        return sut
    }
}
