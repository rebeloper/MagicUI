//
//  AsDestinationForNavigationStep.swift
//  
//
//  Created by Alex Nagy on 18.09.2022.
//

import SwiftUI

public struct AsDestinationForNavigationStep: ViewModifier {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding public var navigationStep: NavigationStep
    
    public func body(content: Content) -> some View {
        content
            .onChange(of: navigationStep.isActive) { isActive in
                if !isActive {
                    dismiss()
                }
            }
    }
}

public extension View {
    func setAsDestinationForNavigationStep(_ navigationStep: Binding<NavigationStep>) -> some View {
        self.modifier(AsDestinationForNavigationStep(navigationStep: navigationStep))
    }
}
