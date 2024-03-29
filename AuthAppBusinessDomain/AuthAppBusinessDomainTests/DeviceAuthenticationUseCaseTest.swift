//
//  Copyright (c) 2023 Ashish Bhandari
//

import AuthAppBusinessDomain
import XCTest

class DeviceAuthenticationUseCaseTest: XCTestCase {
    func test_device_authentication_unlocks_successfully() {
        let (sut, output) = makeSUT()
        XCTAssertEqual(output.results.count, 0)
        sut.didAuthenticate(result: .success("a token"))
        XCTAssertEqual(output.results.count, 1)
        switch output.results.first! {
        case .failure:
            assertionFailure()
        case .success:
            break
        }
    }
    
    func test_device_unlock_followed_by_invalid_remote_authentication_fails_to_login() {
        let (sut, output) = makeSUT()
        XCTAssertEqual(output.results.count, 0)
        sut.didAuthenticate(result: .success("a token"))
        sut.didAuthenticate(result: .failure(.invalidCredential))
        XCTAssertEqual(output.results.count, 2)
        switch (output.results.first!, output.results.last!) {
        case (.success, .failure(let error)):
            XCTAssertEqual(error, .invalidCredentials)
        default:
            assertionFailure()
        }
    }
    
    // MARK: Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (DeviceAuthenticationUseCase, AuthenticationUseCaseOutputSpy) {
        let output = AuthenticationUseCaseOutputSpy()
        let sut = DeviceAuthenticationUseCase(output: output)
        trackMemoryLeak(of: sut)
        trackMemoryLeak(of: output)
        return (sut, output)
    }
    
    private final class AuthenticationUseCaseOutputSpy: AuthenticationUseCaseOutput {
        var results = [Result<AuthAppData, AuthAppError>]()

        func didComplete(result: Result<AuthAppData, AuthAppError>) {
            results.append(result)
        }
    }
}
