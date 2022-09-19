//
//  AsDestinationForNavigationStep.swift
//  
//
//  Created by Alex Nagy on 18.09.2022.
//

import SwiftUI

internal struct AsDestinationForNavigationStep: ViewModifier {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding internal var navigationStep: NavigationStep
    
    internal func body(content: Content) -> some View {
        content
            .onChange(of: navigationStep.isActive) { isActive in
                if !isActive {
                    dismiss()
                }
            }
    }
}

public extension View {
    
    /// Sets this view as the destination from a ``NavigationStep``
    /// - Parameter navigationStep: a ``NavigationStep``
    func setAsDestinationForNavigationStep(_ navigationStep: Binding<NavigationStep>) -> some View {
        self.modifier(AsDestinationForNavigationStep(navigationStep: navigationStep))
    }
}
