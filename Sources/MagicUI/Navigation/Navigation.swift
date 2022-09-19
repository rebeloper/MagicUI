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
    public static func activate(_ path: Binding<NavigationStep>...) {
        if path.count >= 2 {
            for i in 0..<path.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 + 0.6 * Double(i), execute: {
                    path[i].isActive.wrappedValue = true
                })
            }
        } else {
            DispatchQueue.main.async {
                path[0].isActive.wrappedValue = true
            }
        }
    }
    
    /// Deactivates one or more ``NavigationStep``s
    /// - Parameter path: one or more ``NavigationStep``s
    public static func deactivate(_ path: Binding<NavigationStep>...) {
        if path.count >= 2 {
            for i in 0..<path.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 + 0.6 * Double(i), execute: {
                    path[i].isActive.wrappedValue = false
                })
            }
        } else {
            DispatchQueue.main.async {
                path[0].wrappedValue.isActive = false
            }
        }
    }
    
}
