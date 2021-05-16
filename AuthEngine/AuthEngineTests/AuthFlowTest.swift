//
//  AuthFlowTest.swift
//  AuthEngineTests
//
//  Created by Ashish Bhandari - TIL on 13/05/21.
//

import XCTest
@testable import AuthEngine

class AuthFlowTest: XCTestCase {
    private weak var weakSUT: AuthFlow<DelegateSpy>?
    
    override func tearDown() {
        super.tearDown()
        XCTAssertNil(weakSUT)
    }
    
    func test_flow_not_started_route_results_zero() {
        let (_, delegate) = makeSUT()
        XCTAssertEqual(delegate.results.count, 0)
    }

    func test_flow_started_once_route_results_one() {
        let (sut, delegate) = makeSUT()
        sut.start()
        XCTAssertEqual(delegate.results.count, 1)
    }
    
    func test_flow_started_twice_route_results_two() {
        let (sut, delegate) = makeSUT()
        sut.start()
        sut.start()
        XCTAssertEqual(delegate.results.count, 2)
    }
    
    func test_flow_started_without_policies_results_invalidPolicy() {
        let (sut, delegate) = makeSUT(policies: [:])
        sut.start()
        XCTAssertEqual(delegate.results.first, .failure(.invalidPolicy))
    }
    
    func test_flow_started_wrong_policies_results_invalidPolicy() {
        let (sut, delegate) = makeSUT(policies: [.location: PhotoPolicy(authenticate: syncAuthentication)])
        sut.start()
        XCTAssertEqual(delegate.results.first, .failure(.invalidPolicy))
    }
    
    func test_flow_started_correct_policies_results_success() {
        let (sut, delegate) = makeSUT(type: .photo , policies: [.photo: PhotoPolicy(authenticate: syncAuthentication)])
        sut.start()
        XCTAssertEqual(delegate.results.first, .success(true))
    }
    
    //MARK : Helpers
    private func makeSUT(type: AuthType = .location, policies: [AuthType: AuthPolicy] = [.location: LocationPolicy(authenticate: syncAuthentication)]) -> (AuthFlow<DelegateSpy>, DelegateSpy) {
        let delegate = DelegateSpy()
        let sut = AuthFlow(type, delegate, policies)
        weakSUT = sut
        return (sut, delegate)
    }
    
}
