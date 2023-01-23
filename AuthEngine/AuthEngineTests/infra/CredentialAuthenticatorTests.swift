//
//  CredentialAuthenticatorTests.swift
//  AuthEngineTests
//
//  Created by Ashish Bhandari on 22/01/23.
//

import XCTest
@testable import AuthEngine

final class CredentialAuthenticatorTests: XCTestCase {
    func test_authentication_is_possible_only_with_valid_credential() {
        let emptyCredential = CredentialAuthenticator.Credential(userName: "", password: "")
        var sut = makeSUT(credential: emptyCredential)
        XCTAssertFalse(sut.canAuthenticate())
        
        let validCredential = CredentialAuthenticator.Credential(userName: "a username",
                                                             password: "password1")
        sut = makeSUT(credential: validCredential)
        XCTAssertTrue(sut.canAuthenticate())
    }
    
    func test_authetication_fails_when_incorrect_credential() {
        let incorrectCredential = CredentialAuthenticator.Credential(userName: "username",
                                                               password: "password")
        let sut = makeSUT(credential: incorrectCredential)
        XCTAssertTrue(sut.canAuthenticate())
        
        var authError: AuthError?
        sut.authenticate {
            switch $0 {
            case .success:
                break
            case .failure(let error):
                authError = error
            }
        }
        
        XCTAssertEqual(authError, .invalidCredential)
    }
    
    func test_authetication_passes_when_correct_credential() {
        let correctCredential = CredentialAuthenticator.Credential(userName: "username",
                                                             password: "password2")
        let sut = makeSUT(credential: correctCredential)
        XCTAssertTrue(sut.canAuthenticate())
        
        var authError: AuthError?
        sut.authenticate {
            switch $0 {
            case .success:
                break
            case .failure(let error):
                authError = error
            }
        }
        
        XCTAssertNil(authError)
    }
    
    // MARK: Helpers
    private func makeSUT(credential: CredentialAuthenticator.Credential,
                         file: StaticString = #filePath, line: UInt = #line) -> CredentialAuthenticator {
        let sut = CredentialAuthenticator { credential }
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, "Potential memory leak.", file: file, line: line)
        }
        return sut
    }
}
