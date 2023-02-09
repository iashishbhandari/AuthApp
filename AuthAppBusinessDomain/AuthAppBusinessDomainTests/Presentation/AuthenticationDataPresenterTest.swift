//
//  Copyright (c) 2023 Ashish Bhandari
//

import AuthAppBusinessDomain
import XCTest

class AuthenticationDataPresenterTest: XCTestCase {
    func test_didComplete_outputs_correct_result_on_success() {
        let (sut, output) = makeSUT()
        XCTAssertEqual(output.results.count, 0)
        let authModel1 = AuthAppData(token: "token1")
        sut.didComplete(result: .success(authModel1))
        let authModel2 = AuthAppData(token: "token2")
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
        trackMemoryLeak(of: sut)
        trackMemoryLeak(of: output)
        return (sut, output)
    }
    
    final class AuthDataPresenterOutputSpy: AuthenticationDataPresenterOutput {
        var results = [AuthAppData]()
        var errors = [AuthAppError]()

        func onSuccess(data model: AuthAppData) {
            results.append(model)
        }
        
        func onFailure(error: AuthAppError) {
            errors.append(error)
        }
    }
}

extension XCTestCase {
    func trackMemoryLeak(of instance: AnyObject,
                   file: StaticString = #filePath,
                   line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Potential memory leak!", file: file, line: line)
        }
    }
}
