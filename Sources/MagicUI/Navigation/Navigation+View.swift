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
    func navigation<D: View>(_ type: NavigationType, isActive: Binding<Bool>, @ViewBuilder destination: @escaping () -> D, onDismiss: (() -> Void)? = nil) -> some View {
        switch type {
        case .stack:
            if onDismiss != nil { fatalError(".stack type cannot have an onDismiss") }
            self.navigationDestination(isActive: isActive, destination: destination)
        case .sheet:
            self.sheet(isActive: isActive, onDismiss: onDismiss, content: destination)
        case .fullScreenCover:
            self.fullScreenCover(isActive: isActive, onDismiss: onDismiss, content: destination)
        }
    }
    
    @ViewBuilder
    func navigation<D: View>(_ type: NavigationType, isPresented: Binding<Bool>, @ViewBuilder destination: @escaping () -> D, onDismiss: (() -> Void)? = nil) -> some View {
        switch type {
        case .stack:
            if onDismiss != nil { fatalError(".stack type cannot have an onDismiss") }
            self.navigationDestination(isPresented: isPresented, destination: destination)
        case .sheet:
            self.sheet(isPresented: isPresented, onDismiss: onDismiss, content: destination)
        case .fullScreenCover:
            self.fullScreenCover(isPresented: isPresented, onDismiss: onDismiss, content: destination)
        }
    }
    
    func sync(_ published: Binding<Bool>, with binding: Binding<Bool>) -> some View {
        self
            .onChange(of: published.wrappedValue) { published in
                binding.wrappedValue = published
            }
            .onChange(of: binding.wrappedValue) { binding in
                published.wrappedValue = binding
            }
    }
    
    @ViewBuilder
    func navigationDestination<D: View>(isActive: Binding<Bool>, @ViewBuilder destination: @escaping () -> D) -> some View {
        self.modifier(NavigationDestinationPublishedModifier(published: isActive, destination: destination))
    }
    
    @ViewBuilder
    func sheet<D: View>(isActive: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> D) -> some View {
        self.modifier(SheetPublishedModifier(published: isActive, onDismiss: onDismiss, content: content))
    }
    
    @ViewBuilder
    func fullScreenCover<D: View>(isActive: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> D) -> some View {
        self.modifier(FullScreenCoverPublishedModifier(published: isActive, onDismiss: onDismiss, content: content))
    }
    
}

