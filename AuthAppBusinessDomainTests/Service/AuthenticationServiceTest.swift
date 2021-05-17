//
//  AuthenticationServiceTest.swift
//  AuthAppBusinessLogicTests
//
//  Created by Ashish Bhandari - TIL on 16/05/21.
//

import XCTest
@testable import AuthAppBusinessDomain

class RemoteAuthenticationServiceTest: XCTestCase {
    
    func test_() {
        let sut = RemoteAuthenticationService()
        XCTAssertEqual(sut.getAuthType(from: .location), .location)
        XCTAssertEqual(sut.getAuthType(from: .photo), .photo)
        XCTAssertEqual(sut.getAuthType(from: .video), .video)
    }
    
    func test_authenticate_creates_an_authContext() {
        let sut = RemoteAuthenticationService()
        XCTAssertNil(sut.authContext)
        sut.authenticate(.location) { _ in}
        XCTAssertNotNil(sut.authContext)
    }

    func test_authenticate_once_resultsCount_one_withCorrectData() {
        let sut = RemoteAuthenticationService()
        var results = [Result<Bool, AuthAppError>]()
        sut.authenticate(.location) {
            results.append($0)
        }
        XCTAssertEqual(results.count, 0)
        sut.didAuthenticate(type: .location, result: .success(true))
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first, .success(true))
    }
    
    func test_authenticate_twice_resultsCount_two_withCorrectData() {
        let sut = RemoteAuthenticationService()
        var results = [Result<Bool, AuthAppError>]()
        sut.authenticate(.location) {
            results.append($0)
        }
        XCTAssertEqual(results.count, 0)
        sut.didAuthenticate(type: .location, result: .success(false))
        sut.didAuthenticate(type: .photo, result: .failure(.invalidAuthType))
        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results.first, .success(false))
        XCTAssertEqual(results.last, .failure(.serviceError))
    }
}
