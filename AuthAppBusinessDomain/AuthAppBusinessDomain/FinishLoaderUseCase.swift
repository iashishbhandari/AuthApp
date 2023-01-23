//
//  Copyright (c) 2023 Ashish Bhandari
//

import Foundation

public final class FinishLoaderUseCase {
    private var output: FinishLoaderUseCaseOutput
    
    public init(output: FinishLoaderUseCaseOutput) {
        self.output = output
    }
    
    public func complete() {
        output.onCompleteLoading()
    }
}

public protocol FinishLoaderUseCaseOutput {
    func onCompleteLoading()
}
