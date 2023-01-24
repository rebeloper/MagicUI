//
//  RootNavigationStack.swift
//
//  Created by Alex Nagy on 19.01.2023.
//

import SwiftUI

internal struct RootNavigationStack<Root: View, Destination: RouterDestination>: View {
    
    @EnvironmentObject private var routes: Routes<Destination>
    
    internal let pathIndex: Int
    internal let tabIndex: Int
    internal let presentationDetents: Set<PresentationDetent>
    internal let presentationDragIndicatorVisibility: Visibility
    @ViewBuilder internal var root: () -> Root
    
    internal init(pathIndex: Int,
                  tabIndex: Int,
                  presentationDetents: Set<PresentationDetent> = [],
                  presentationDragIndicator visibility: Visibility = .automatic,
                  @ViewBuilder root: @escaping () -> Root) {
        self.pathIndex = pathIndex
        self.tabIndex = tabIndex
        self.presentationDetents = presentationDetents
        self.presentationDragIndicatorVisibility = visibility
        self.root = root
    }
    
    internal var body: some View {
        NavigationStack(path: $routes.paths[tabIndex][pathIndex]) {
            Destination(modalValue: pathIndex)
                .navigationDestination(for: Destination.self) { $0 }
        }
        .presentationDetents(presentationDetents)
        .presentationDragIndicator(presentationDragIndicatorVisibility)
        .onAppear {
            routes.pathIndex[tabIndex] = pathIndex
        }
    }
}

