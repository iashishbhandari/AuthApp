//
//  Copyright (c) 2023 Ashish Bhandari
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
