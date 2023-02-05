//
//  Copyright (c) 2023 Ashish Bhandari
//

import XCTest
@testable import AuthAppBusinessDomain

class CredentialAuthenticationUseCaseTest: XCTestCase {
    func test_credential_authentication_success_results_in_correctData() {
        let credential = LoginCredential(username: "a username",
                                         password: "password1")
        let (sut, output) = makeSUT(credential)
        XCTAssertEqual(output.results.count, 0)
        sut.didAuthenticate(result: .success("a token"))
        XCTAssertEqual(output.results.count, 1)
        switch output.results.first {
        case .success(let authData):
            XCTAssertEqual(authData.token, "a token")
            XCTAssertEqual(authData.credential, credential)
        default:
            assertionFailure()
        }
    }
    
    func test_credential_authentication_success_followed_by_failure_results_in_correctData() {
        let credential = LoginCredential(username: "username",
                                         password: "password2")
        let (sut, output) = makeSUT(credential)
        XCTAssertEqual(output.results.count, 0)
        sut.didAuthenticate(result: .success("token"))
        sut.didAuthenticate(result: .failure(.invalidCredential))
        XCTAssertEqual(output.results.count, 2)
        switch (output.results.first, output.results.last) {
        case let (.success(authData), .failure(error)):
            XCTAssertEqual(authData.token, "token")
            XCTAssertEqual(authData.credential, credential)
            XCTAssertEqual(error, .invalidCredentials)
        default:
            assertionFailure()
        }
    }
    
    // MARK: Helpers
    private func makeSUT(_ credential: LoginCredential?,
                         file: StaticString = #filePath, line: UInt = #line)
    -> (CredentialAuthenticationUseCase, AuthenticationUseCaseOutputStub) {
        let output = AuthenticationUseCaseOutputStub(credential)
        let sut = CredentialAuthenticationUseCase(output: output)
        trackMemoryLeak(of: sut)
        trackMemoryLeak(of: output)
        return (sut, output)
    }
    
    private final class AuthenticationUseCaseOutputStub: AuthenticationUseCaseOutput {
        let credential: LoginCredential?
        
        init(_ credential: LoginCredential?) {
            self.credential = credential
        }
        
        var results = [Result<AuthAppData, AuthAppError>]()

        func didComplete(result: Result<AuthAppData, AuthAppError>) {
            switch result {
            case .success(let authData):
                results.append(.success(.init(token: authData.token,
                                              credential: credential)))
            case .failure(let error):
                results.append(.failure(error))
            }
        }
    }
}
