//
//  RouterStack.swift
//
//  Created by Alex Nagy on 07.01.2023.
//

import SwiftUI

public struct RouterStack<Destination: RouterDestination>: View {
    
    @StateObject private var routes: Routes<Destination>
    
    private var roots: [Destination]
    
    #if os(iOS) || os(watchOS)
    public init(roots: [Destination]) {
        self.roots = roots
        let routes = Routes<Destination>()
        for i in 0..<roots.count {
            routes.activeModalsIndices.append([roots[i].rawValue])
        }
        self._routes = StateObject(wrappedValue: routes)
    }
    #endif
    
    public init(root: Destination) {
        self.roots = [root]
        let routes = Routes<Destination>()
        for i in 0..<roots.count {
            routes.activeModalsIndices.append([roots[i].rawValue])
        }
        self._routes = StateObject(wrappedValue: routes)
    }
    
    public var body: some View {
        RootNavigationStack<Destination, Destination>(pathIndex: roots[0].rawValue, tabIndex: 0) {
            roots[0]
        }
        .environmentObject(routes)
        .onReceive(routes.$activeModalsIndices) { newValue in
            routes.pathIndex[routes.tabSelection] = newValue[routes.tabSelection].count - 1
        }
    }
}
