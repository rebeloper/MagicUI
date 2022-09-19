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

/// Convenience ``ObservableObject`` that you can subclass for ``NavigationDestination``s
open class NavigationObservable: ObservableObject {
    public init() {}
}

public struct NavigationDestination {
    public var isActive: Bool
    public let type: NavigationType
    
    public init(type: NavigationType) {
        self.isActive = false
        self.type = type
    }
}

public extension View {
    
    @ViewBuilder
    func navigationDestination<D: View>(_ destination: Binding<NavigationDestination>, @ViewBuilder content: @escaping () -> D, onDismiss: (() -> Void)? = nil) -> some View {
        switch destination.wrappedValue.type {
        case .stack:
            if onDismiss != nil { fatalError(".stack type cannot have an onDismiss") }
            self.navigationDestination(isActive: destination.isActive, content: content)
        case .sheet:
            self.sheet(isActive: destination.isActive, onDismiss: onDismiss, content: content)
        case .fullScreenCover:
            self.fullScreenCover(isActive: destination.isActive, onDismiss: onDismiss, content: content)
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
    private func navigationDestination<D: View>(isActive: Binding<Bool>, @ViewBuilder content: @escaping () -> D) -> some View {
        self.modifier(NavigationDestinationPublishedModifier(published: isActive, destination: content))
    }
    
    @ViewBuilder
    private func sheet<D: View>(isActive: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> D) -> some View {
        self.modifier(SheetPublishedModifier(published: isActive, onDismiss: onDismiss, content: content))
    }
    
    @ViewBuilder
    private func fullScreenCover<D: View>(isActive: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> D) -> some View {
        self.modifier(FullScreenCoverPublishedModifier(published: isActive, onDismiss: onDismiss, content: content))
    }
    
}

