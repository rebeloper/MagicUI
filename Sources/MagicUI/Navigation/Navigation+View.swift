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
    func navigation<D: View>(_ type: NavigationType, destination: Binding<Bool>, @ViewBuilder content: @escaping () -> D, onDismiss: (() -> Void)? = nil) -> some View {
        switch type {
        case .stack:
            if onDismiss != nil { fatalError(".stack type cannot have an onDismiss") }
            self.navigationDestination(destination: destination, content: content)
        case .sheet:
            self.sheet(destination: destination, onDismiss: onDismiss, content: content)
        case .fullScreenCover:
            self.fullScreenCover(destination: destination, onDismiss: onDismiss, content: content)
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
    private func navigationDestination<D: View>(destination: Binding<Bool>, @ViewBuilder content: @escaping () -> D) -> some View {
        self.modifier(NavigationDestinationPublishedModifier(published: destination, destination: content))
    }
    
    @ViewBuilder
    private func sheet<D: View>(destination: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> D) -> some View {
        self.modifier(SheetPublishedModifier(published: destination, onDismiss: onDismiss, content: content))
    }
    
    @ViewBuilder
    private func fullScreenCover<D: View>(destination: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> D) -> some View {
        self.modifier(FullScreenCoverPublishedModifier(published: destination, onDismiss: onDismiss, content: content))
    }
    
}

