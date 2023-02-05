//
//  Copyright (c) 2023 Ashish Bhandari
//

import LocalAuthentication
import XCTest
@testable import AuthEngine

final class DeviceAuthenticatorTests: XCTestCase {
    func test_authentication_is_possible_only_with_valid_policy() {
        var invalidPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometricsOrWatch
        var sut = makeSUT(policy: invalidPolicy)
        XCTAssertFalse(sut.canAuthenticate())
        invalidPolicy = LAPolicy.deviceOwnerAuthenticationWithWatch
        sut = makeSUT(policy: invalidPolicy)
        XCTAssertFalse(sut.canAuthenticate())
        
        var validPolicy = LAPolicy.deviceOwnerAuthentication
        sut = makeSUT(policy: validPolicy)
        XCTAssertTrue(sut.canAuthenticate())
        validPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        sut = makeSUT(policy: validPolicy)
        XCTAssertTrue(sut.canAuthenticate())
    }
    
    func test_authetication_fails_when_incorrect_policy() {
        let sut = makeSUT(policy: .deviceOwnerAuthenticationWithWatch)

        var authError: AuthError?
        sut.authenticate {
            switch $0 {
            case .success:
                break
            case .failure(let error):
                authError = error
            }
        }

        XCTAssertEqual(authError, .invalidPolicy)
    }

    func test_authetication_passes_when_correct_policy() {
        let sut = makeSUT(policy: .deviceOwnerAuthentication)

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
    private func makeSUT(policy: LAPolicy, file: StaticString = #filePath, line: UInt = #line) -> DeviceAuthenticator {
        let sut = DeviceAuthenticator(authContext: StubLAContext(policy))
        trackMemoryLeak(of: sut)
        return sut
    }
}

final class StubLAContext: LAContext {
    let policy: LAPolicy

    init(_ policy: LAPolicy) {
        self.policy = policy
    }
    
    override func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
        policy == self.policy
    }
    
    override func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void) {
        reply(policy == self.policy, nil)
    }
}
