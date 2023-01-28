//
//  RouterStack.swift
//
//  Created by Alex Nagy on 19.01.2023.
//

import SwiftUI

public struct RouterStack<Destination: RouterDestination>: View {
    
    @StateObject private var router: Router<Destination>
    
    private var roots: [Destination]
    
    /// Creates a navigation stack with homogeneous navigation state that you
    /// can control.
    ///
    /// - Parameter root: The view to display when the stack is empty.
    public init(root: Destination) {
        self.roots = [root]
        let router = Router<Destination>()
        for i in 0..<roots.count {
            router.activeModalsIndices.append([roots[i].modalValue])
        }
        self._router = StateObject(wrappedValue: router)
    }
    
    public var body: some View {
        Group {
            RootNavigationStack<Destination, Destination>(pathIndex: roots[0].modalValue, tabIndex: 0) {
                roots[0]
            }
        }
        .environmentObject(router)
        .onReceive(router.$activeModalsIndices) { newValue in
            guard newValue.count - 1 >= router.tabSelection, newValue[router.tabSelection].count >= 1 else { return }
            router.pathIndex[router.tabSelection] = newValue[router.tabSelection].count - 1
        }
    }
}

