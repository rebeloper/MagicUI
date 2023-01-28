//
//  Routes.swift
//
//  Created by Alex Nagy on 19.01.2023.
//

import SwiftUI

public class Routes<Destination: RouterDestination>: ObservableObject {
    
    @Published public var modalsState = Array(repeating: Array(repeating: false, count: 100), count: 10)
    @Published public var activeModalsIndices = [[Int]]()
    @Published public var tabSelection = 0
    
    @Published public var paths = Array(repeating: Array(repeating: NavigationPath(), count: 100), count: 10)
    @Published public var pathIndex = Array(repeating: 0, count: 10)
    
    public func push(_ destination: Destination, completion: @escaping () -> () = {}) {
        guard pathIndex[tabSelection] < paths[tabSelection].count else { return }
        DispatchQueue.main.async {
            self.paths[self.tabSelection][self.pathIndex[self.tabSelection]].append(destination)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    public func dismiss(completion: @escaping () -> ()) {
        guard pathIndex[tabSelection] < paths[tabSelection].count, !paths[tabSelection][pathIndex[tabSelection]].isEmpty else { return }
        DispatchQueue.main.async {
            self.paths[self.tabSelection][self.pathIndex[self.tabSelection]].removeLast()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    public func present(_ isActive: Binding<Bool>, completion: @escaping () -> () = {}) {
        DispatchQueue.main.async {
            isActive.wrappedValue = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    public func dismissModal(_ isActive: Binding<Bool>, completion: @escaping () -> () = {}) {
        DispatchQueue.main.async {
            isActive.wrappedValue = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
}

