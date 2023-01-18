//
//  ViewComposerFactory.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 21/05/21.
//

import AuthAppBusinessDomain
import SwiftUI

typealias AppDelegate = FinishLoaderUseCaseOutput & ResetAuthStateUseCaseOutput

protocol AppViewComposerFactory {
    func composedViewModel(for viewType: AppViewType, delegate: AppDelegate) -> AppViewModel
}

enum AppViewType {
    case authenticater
    case loader
}

enum AppViewModel {
    case authenticater(AuthenticationViewModel)
    case loader(LoaderViewModel)
}
