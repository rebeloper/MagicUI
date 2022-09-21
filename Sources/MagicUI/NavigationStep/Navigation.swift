//
//  Navigation.swift
//  
//
//  Created by Alex Nagy on 16.09.2022.
//

import SwiftUI

public struct Navigation {
    
    /// Activates one or more ``NavigationStep``s
    /// - Parameter path: one or more ``NavigationStep``s
    @MainActor
    public static func activate(_ path: Binding<NavigationStep>...) {
        Task {
            if path.count >= 2 {
                for i in 0..<path.count {
                    do {
                        try await Task.sleep(nanoseconds: 100_000_000 + UInt64(600_000_000 * i)) // 1 second = 1_000_000_000 nanoseconds
                        path[i].isActive.wrappedValue = true
                    } catch {
                        print("Navigation error: \(error.localizedDescription)")
                    }
                }
            } else {
                path[0].isActive.wrappedValue = true
            }
        }
    }
    
    /// Deactivates one or more ``NavigationStep``s
    /// - Parameter path: one or more ``NavigationStep``s
    @MainActor
    public static func deactivate(_ path: Binding<NavigationStep>...) {
        Task {
            if path.count >= 2 {
                for i in 0..<path.count {
                    do {
                        try await Task.sleep(nanoseconds: 100_000_000 + UInt64(600_000_000 * i)) // 1 second = 1_000_000_000 nanoseconds
                        path[i].isActive.wrappedValue = false
                    } catch {
                        print("Navigation error: \(error.localizedDescription)")
                    }
                }
            } else {
                path[0].isActive.wrappedValue = false
            }
        }
    }
    
}
