//
//  Copyright (c) 2023 Ashish Bhandari
//

import XCTest
@testable import AuthAppBusinessDomain

class AuthenticationDataPresenterTest: XCTestCase {
    func test_didComplete_outputs_correct_result_on_success() {
        let (sut, output) = makeSUT()
        XCTAssertEqual(output.results.count, 0)
        let authModel1 = AuthAppModel(token: "token1")
        sut.didComplete(result: .success(authModel1))
        let authModel2 = AuthAppModel(token: "token2")
        sut.didComplete(result: .success(authModel2))
        XCTAssertEqual(output.results.count, 2)
        XCTAssertEqual(output.results.first, authModel1)
        XCTAssertEqual(output.results.last, authModel2)
    }
    
    func test_didComplete_outputs_correct_result_on_failure() {
        let (sut, output) = makeSUT()
        XCTAssertEqual(output.errors.count, 0)
        sut.didComplete(result: .failure(.invalidCredentials))
        sut.didComplete(result: .failure(.invalidCredentials))
        XCTAssertEqual(output.errors.count, 2)
        XCTAssertEqual(output.errors.first, .invalidCredentials)
        XCTAssertEqual(output.errors.last, .invalidCredentials)
    }
        
    // MARK: Helpers
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (AuthenticationDataPresenter, AuthDataPresenterOutputSpy) {
        let output = AuthDataPresenterOutputSpy()
        let sut = AuthenticationDataPresenter(output: output)
        addTeardownBlock { [weak sut, weak output] in
            XCTAssertNil(sut, "Potential memory leak.", file: file, line: line)
            XCTAssertNil(output, "Potential memory leak.", file: file, line: line)
        }
        return (sut, output)
    }
    
    final class AuthDataPresenterOutputSpy: AuthDataPresenterOutput {
        var results = [AuthAppModel]()
        var errors = [AuthAppError]()

        func onSuccess(model: AuthAppModel) {
            results.append(model)
        }
        
        func onFailure(error: AuthAppError) {
            errors.append(error)
        }
    }
}
