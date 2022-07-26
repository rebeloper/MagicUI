//
//  NavigationRoot.swift
//  
//
//  Created by Alex Nagy on 04.07.2022.
//

import SwiftUI

public struct NavigationRoot<R, D, C>: View where R: View, D : Hashable, C : View {
    
    @ObservedObject var navigation: Navigation
    let root: () -> R
    let data: D.Type
    @ViewBuilder let destination: (D) -> C
    
    public init(navigation: Navigation,
                _ root: @escaping () -> R,
                with data: D.Type,
                @ViewBuilder destination: @escaping (D) -> C) {
        self.navigation = navigation
        self.root = root
        self.data = data
        self.destination = destination
    }
    
    public var body: some View {
        NavigationStack(path: $navigation.paths[0]) {
            root()
                .navigationDestination(for: data, destination: destination)
        }
        .environmentObject(navigation)
    }
}

public extension View {
    func asNavigationRoot<D, C>(navigation: Navigation,
                              with data: D.Type,
                              @ViewBuilder destination: @escaping (D) -> C) -> some View where D : Hashable, C : View {
        NavigationRoot(navigation: navigation, {
            self
        }, with: data, destination: destination)
    }
}
