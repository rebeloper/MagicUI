//
//  DismissHandler.swift
//  
//
//  Created by Alex Nagy on 18.09.2022.
//

import SwiftUI

internal struct DismissHandler: ViewModifier {
    
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
    func isDismissHandler(for navigationStep: Binding<NavigationStep>) -> some View {
        self.modifier(DismissHandler(navigationStep: navigationStep))
    }
}
