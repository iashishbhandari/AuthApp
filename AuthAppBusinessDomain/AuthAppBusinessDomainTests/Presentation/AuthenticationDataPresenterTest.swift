//
//  AuthenticationDataPresenterTest.swift
//  AuthAppBusinessLogicTests
//
//  Created by Ashish Bhandari - TIL on 16/05/21.
//

import XCTest
@testable import AuthAppBusinessDomain

class AuthenticationDataPresenterTest: XCTestCase {

    func test_didCompleteSuccess_once_resultsCount_One_withCorrectData() {
        let output = AuthDataPresenterOutputSpy()
        let sut = AuthenticationDataPresenter(output: output)
        XCTAssertEqual(output.results.count, 0)
        sut.didComplete(for: .location, result: .success(true))
        XCTAssertEqual(output.results.count, 1)
        XCTAssertEqual(output.results.first!.isAuthorised, true)
        XCTAssertEqual(output.results.first!.type, .location)
        XCTAssertEqual(output.results.first!.imageName, "lock.open")
        XCTAssertEqual(output.results.first!.resultText, "Authorised")
    }
    
    func test_didCompleteSuccess_twice_resultsCount_Two_withCorrectData() {
        let output = AuthDataPresenterOutputSpy()
        let sut = AuthenticationDataPresenter(output: output)
        XCTAssertEqual(output.results.count, 0)
        sut.didComplete(for: .location, result: .success(true))
        sut.didComplete(for: .photo, result: .success(false))
        XCTAssertEqual(output.results.count, 2)
        XCTAssertEqual(output.results.first?.isAuthorised, true)
        XCTAssertEqual(output.results.first?.type, .location)
        XCTAssertEqual(output.results.first!.imageName, "lock.open")
        XCTAssertEqual(output.results.first!.resultText, "Authorised")
        XCTAssertEqual(output.results.last?.isAuthorised, false)
        XCTAssertEqual(output.results.last?.type, .photo)
        XCTAssertEqual(output.results.last!.imageName, "lock")
        XCTAssertEqual(output.results.last!.resultText, "Not Authorised")
    }
    
    func test_didCompleteFailure_once_resultsCount_One_withCorrectData() {
        let output = AuthDataPresenterOutputSpy()
        let sut = AuthenticationDataPresenter(output: output)
        XCTAssertEqual(output.errors.count, 0)
        sut.didComplete(for: .location, result: .failure(.serviceError))
        XCTAssertEqual(output.errors.count, 1)
        XCTAssertEqual(output.errors.first?.type, .serviceError)
        XCTAssertFalse(output.errors.first!.title.isEmpty)
        XCTAssertFalse(output.errors.first!.message.isEmpty)
    }
    
    func test_didCompleteFailure_twice_resultsCount_Two_withCorrectData() {
        let output = AuthDataPresenterOutputSpy()
        let sut = AuthenticationDataPresenter(output: output)
        XCTAssertEqual(output.errors.count, 0)
        sut.didComplete(for: .location, result: .failure(.serviceError))
        sut.didComplete(for: .location, result: .failure(.unknown))
        XCTAssertEqual(output.errors.count, 2)
        XCTAssertEqual(output.errors.first?.type, .serviceError)
        XCTAssertFalse(output.errors.first!.title.isEmpty)
        XCTAssertFalse(output.errors.first!.message.isEmpty)
        XCTAssertEqual(output.errors.last?.type, .unknown)
        XCTAssertFalse(output.errors.last!.title.isEmpty)
        XCTAssertFalse(output.errors.last!.message.isEmpty)
    }
}
