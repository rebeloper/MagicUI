//
//  RootModalNavigationStack.swift
//  
//
//  Created by Alex Nagy on 28.09.2022.
//

import SwiftUI

internal struct RootModalNavigationStack<Root: View>: View {
    
    @EnvironmentObject private var router: Router
    
    internal let index: Int
    internal let presentationDetents: Set<PresentationDetent>
    internal let presentationDragIndicatorVisibility: Visibility
    @ViewBuilder internal var root: () -> Root
    
    internal init(index: Int, presentationDetents: Set<PresentationDetent> = [], presentationDragIndicator visibility: Visibility = .automatic, @ViewBuilder root: @escaping () -> Root) {
        self.index = index
        self.presentationDetents = presentationDetents
        self.presentationDragIndicatorVisibility = visibility
        self.root = root
    }
    
    internal init(presentationDetents: Set<PresentationDetent> = [], presentationDragIndicator visibility: Visibility, @ViewBuilder root: @escaping () -> Root) {
        self.index = 0
        self.presentationDetents = presentationDetents
        self.presentationDragIndicatorVisibility = visibility
        self.root = root
    }
    
    internal var body: some View {
        NavigationStack(path: $router.paths[index], root: root)
            .presentationDetents(presentationDetents)
            .presentationDragIndicator(presentationDragIndicatorVisibility)
            .onAppear {
                router.pathIndex = index
            }
    }
}


