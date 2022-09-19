//
//  Navigation+View.swift
//  StringNavigation
//
//  Created by Alex Nagy on 08.08.2022.
//

//
//  Navigation.swift
//  SwiftUI4BetaNavigation
//
//  Created by Alex Nagy on 24.08.2022.
//

import SwiftUI

public extension View {
    
    @ViewBuilder
    func navigationStep<D: View>(_ step: Binding<NavigationStep>, @ViewBuilder destination: @escaping () -> D, onDismiss: (() -> Void)? = nil) -> some View {
        switch step.wrappedValue.type {
        case .stack:
            if onDismiss != nil { fatalError(".stack type cannot have an onDismiss") }
            self.navigationDestination(isActive: step.isActive, destination: destination)
        case .sheet:
            self.sheet(isActive: step.isActive, onDismiss: onDismiss, destination: destination)
        case .fullScreenCover:
            self.fullScreenCover(isActive: step.isActive, onDismiss: onDismiss, destination: destination)
        }
    }
    
    internal func sync(_ published: Binding<Bool>, with binding: Binding<Bool>) -> some View {
        self
            .onChange(of: published.wrappedValue) { published in
                binding.wrappedValue = published
            }
            .onChange(of: binding.wrappedValue) { binding in
                published.wrappedValue = binding
            }
    }
    
    @ViewBuilder
    private func navigationDestination<D: View>(isActive: Binding<Bool>, @ViewBuilder destination: @escaping () -> D) -> some View {
        self.modifier(NavigationDestinationPublishedModifier(published: isActive, destination: destination))
    }
    
    @ViewBuilder
    private func sheet<D: View>(isActive: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder destination: @escaping () -> D) -> some View {
        self.modifier(SheetPublishedModifier(published: isActive, onDismiss: onDismiss, content: destination))
    }
    
    @ViewBuilder
    private func fullScreenCover<D: View>(isActive: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder destination: @escaping () -> D) -> some View {
        self.modifier(FullScreenCoverPublishedModifier(published: isActive, onDismiss: onDismiss, content: destination))
    }
    
}

