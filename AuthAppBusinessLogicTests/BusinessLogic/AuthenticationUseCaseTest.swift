//
//  AuthenticationUseCaseTest.swift
//  AuthAppBusinessLogicTests
//
//  Created by Ashish Bhandari - TIL on 16/05/21.
//

import XCTest
import AuthEngine
@testable import AuthAppBusinessLogic

class AuthenticationUseCaseTest: XCTestCase {

    func test_authenticate_once_resultsCount_one_withCorrectData() {
        let output = AuthenticationUseCaseOutputSpy()
        let sut = AuthenticationUseCase(service: MockAuthenticationService.success, output: output)
        XCTAssertEqual(output.results.count, 0)
        sut.authenticate(.location)
        XCTAssertEqual(output.results.count, 1)
        XCTAssertEqual(output.results.first!.type, .location)
        XCTAssertEqual(output.results.first!.result, .success(true))
    }
    
    func test_authenticate_twice_resultsCount_two_withCorrectData() {
        let output = AuthenticationUseCaseOutputSpy()
        var sut = AuthenticationUseCase(service: MockAuthenticationService.success, output: output)
        XCTAssertEqual(output.results.count, 0)
        sut.authenticate(.location)
        sut = AuthenticationUseCase(service: MockAuthenticationService.failure(.invalidCredential), output: output)
        sut.authenticate(.photo)
        XCTAssertEqual(output.results.count, 2)
        XCTAssertEqual(output.results.first!.type, .location)
        XCTAssertEqual(output.results.first!.result, .success(true))
        XCTAssertEqual(output.results.last!.type, .photo)
        XCTAssertEqual(output.results.last!.result, .failure(.invalidCredential))
    }
}

private final class AuthenticationUseCaseOutputSpy: AuthenticationUseCaseOutput {
    var results = [(type: AuthType, result: Result<Bool, AuthError>)]()
    
    func didComplete(for type: AuthType, result: Result<Bool, AuthError>) {
        results.append((type: type, result: result))
    }
}

private enum MockAuthenticationService: AuthenticationService {
    case success
    case failure(AuthError)
    
    func authenticate(_ type: AuthType, completion: @escaping (Result<Bool, AuthError>) -> Void) {
        switch self {
        case .success:
            completion(.success(true))
        case .failure(let type):
            completion(.failure(type))
        }
    }
}
