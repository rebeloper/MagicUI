//
//  RootNavigationStack.swift
//  
//
//  Created by Alex Nagy on 28.09.2022.
//

import SwiftUI

/// Creates a navigation stack with heterogeneous navigation state that you
/// can control. Associates a destination view with a presented data type for use within
/// a navigation stack.
///
/// - Parameters:
///   - data: The type of data that this destination matches.
///   - destination: A view builder that defines a view to display
///     when the stack's navigation state contains a value of
///     type `data`. The closure takes one argument, which is the value
///     of the data to present.
///   - root: The view to display when the stack is empty.
public struct RootNavigationStack<D: Hashable, C: View, Root: View>: View {
    
    @StateObject private var router = Router()
    
    private var data: D.Type
    @ViewBuilder private var destination: (D) -> C
    @ViewBuilder private var root: () -> Root
    
    /// Creates a navigation stack with heterogeneous navigation state that you
    /// can control. Associates a destination view with a presented data type for use within
    /// a navigation stack.
    ///
    /// - Parameters:
    ///   - data: The type of data that this destination matches.
    ///   - destination: A view builder that defines a view to display
    ///     when the stack's navigation state contains a value of
    ///     type `data`. The closure takes one argument, which is the value
    ///     of the data to present.
    ///   - root: The view to display when the stack is empty.
    public init(for data: D.Type, @ViewBuilder _ destination: @escaping (D) -> C, @ViewBuilder root: @escaping () -> Root) {
        self.data = data
        self.destination = destination
        self.root = root
    }
    
    public var body: some View {
        NavigationStack(path: $router.paths[0]) {
            root()
                .navigationDestination(for: data, destination: destination)
        }
        .environmentObject(router)
        .onAppear {
            router.pathIndex = 0
        }
    }
}

