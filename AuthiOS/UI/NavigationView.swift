//
//  NavigationView.swift
//  AuthiOS
//
//  Created by Ashish Bhandari - TIL on 16/05/21.
//

import SwiftUI

struct NavigationView: View {
    @ObservedObject var store: AppNavigationStore
    
    var body: some View {
        store.view
            .transition(
                AnyTransition
                    .opacity
                    .combined(with: .move(edge: .trailing))
            )
            .id(UUID())
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView(store: AppNavigationStore())
    }
}
