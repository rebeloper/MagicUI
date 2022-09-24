//
//  Navigation.swift
//  
//
//  Created by Alex Nagy on 16.09.2022.
//

import SwiftUI

public struct Navigation {
    
    /// Activates one or more ``NavigationStep``s
    /// - Parameter steps: one or more ``NavigationStep``s
    public static func present(_ steps: Binding<NavigationStep>...) {
        if steps.count >= 2 {
            for i in 0..<steps.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 + 0.6 * Double(i), execute: {
                    steps[i].isActive.wrappedValue = true
                })
            }
        } else {
            DispatchQueue.main.async {
                steps[0].isActive.wrappedValue = true
            }
        }
    }
    
    /// Deactivates more than one ``NavigationStep``s
    /// - Parameter steps: more than one ``NavigationStep``s
    public static func dismiss(_ steps: Binding<NavigationStep>...) {
        guard steps.count >= 2 else { fatalError("`steps` must have more than one NavigationStep. If you'd like to dismiss only one NavigationStep, please use the `dismiss()` DismissAction instead.") }
        for i in 0..<steps.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 + 0.6 * Double(i), execute: {
                steps[i].isActive.wrappedValue = false
            })
        }
    }
    
}
