//
//  RouterStack.swift
//
//  Created by Alex Nagy on 19.01.2023.
//

import SwiftUI

public struct RouterStack<Destination: RouterDestination>: View {
    
    @StateObject private var routes: Routes<Destination>
    
    private var roots: [Destination]
    
    /// Creates a navigation stack with homogeneous navigation state that you
    /// can control.
    ///
    /// - Parameter root: The view to display when the stack is empty.
    public init(root: Destination) {
        self.roots = [root]
        let routes = Routes<Destination>()
        for i in 0..<roots.count {
            routes.activeModalsIndices.append([roots[i].modalValue])
        }
        self._routes = StateObject(wrappedValue: routes)
    }
    
    public var body: some View {
        Group {
            RootNavigationStack<Destination, Destination>(pathIndex: roots[0].modalValue, tabIndex: 0) {
                roots[0]
            }
        }
        .environmentObject(routes)
        .onReceive(routes.$activeModalsIndices) { newValue in
            guard newValue.count - 1 >= routes.tabSelection, newValue[routes.tabSelection].count >= 1 else { return }
            routes.pathIndex[routes.tabSelection] = newValue[routes.tabSelection].count - 1
        }
    }
}
