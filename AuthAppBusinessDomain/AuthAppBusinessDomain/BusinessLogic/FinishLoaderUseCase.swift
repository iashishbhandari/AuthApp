//
//  FinishLoaderUseCase.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 16/05/21.
//

import Foundation

public protocol FinishLoaderUseCaseOutput {
    func onCompleteLoading()
}

public final class FinishLoaderUseCase {
    private var output: FinishLoaderUseCaseOutput
    
    public init(output: FinishLoaderUseCaseOutput) {
        self.output = output
    }
    
    public func complete() {
        output.onCompleteLoading()
    }
}
