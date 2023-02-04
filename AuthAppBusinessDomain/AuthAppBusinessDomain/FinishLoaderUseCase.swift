//
//  Copyright (c) 2023 Ashish Bhandari
//

import Foundation

public typealias FinishLoaderUseCaseOutput = () -> Void

public final class FinishLoaderUseCase {
    private var output: FinishLoaderUseCaseOutput
    
    public init(output: @escaping FinishLoaderUseCaseOutput) {
        self.output = output
    }
    
    public func complete() {
        output()
    }
}
