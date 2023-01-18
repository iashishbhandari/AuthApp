//
//  ResetAuthStateUseCase.swift
//  AuthAppBusinessLogic
//
//  Created by Ashish Bhandari - TIL on 16/05/21.
//

import Foundation

final public class ResetAuthStateUseCase {
    private var output: ResetAuthStateUseCaseOutput
    
    public init(output: ResetAuthStateUseCaseOutput) {
        self.output = output
    }
    
    public func reset() {
        output.onResetAuthState()
    }
}

public protocol ResetAuthStateUseCaseOutput {
    func onResetAuthState()
}
