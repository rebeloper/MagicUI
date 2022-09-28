//
//  NavigationRouter.swift
//  
//
//  Created by Alex Nagy on 28.09.2022.
//

import SwiftUI

public struct NavigationRouter<D: Hashable, C: View, Root: View>: View {
    
    @StateObject private var router = Router()
    
    public var data: D.Type
    @ViewBuilder public var destination: (D) -> C
    @ViewBuilder public var root: () -> Root
    
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

