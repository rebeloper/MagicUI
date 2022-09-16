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
    func navigation<D: View>(push: Binding<NavigationPush>, @ViewBuilder destination: @escaping () -> D, onDismiss: (() -> Void)? = nil) -> some View {
        switch push.wrappedValue.type {
        case .stack:
            if onDismiss != nil { fatalError(".stack type cannot have an onDismiss") }
            self.navigationDestination(isPublished: push.isActive, destination: destination)
        case .sheet:
            self.sheet(isPublished: push.isActive, onDismiss: onDismiss, content: destination)
        case .fullScreenCover:
            self.fullScreenCover(isPublished: push.isActive, onDismiss: onDismiss, content: destination)
        }
    }
    
    func navigation(pop: Binding<NavigationPop>, destination: Binding<Bool>) -> some View {
        self.onAppear {
            destination.wrappedValue = false
        }.onDisappear {
            if pop.isActive.wrappedValue {
                destination.wrappedValue = true
            }
        }
    }
    
    func navigationBridgeForPop(destination: Binding<Bool>, push: Binding<NavigationPush>, dismiss: DismissAction) -> some View {
        self.onChange(of: push.isActive.wrappedValue) { newValue in
            if push.type.wrappedValue == .stack {
                if !newValue, destination.wrappedValue {
                    dismiss()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                    if !newValue, destination.wrappedValue {
                        dismiss()
                    }
                })
            }
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
    
    func sheet<D: View>(isPublished: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> D) -> some View {
        self.modifier(SheetPublishedModifier(published: isPublished, onDismiss: onDismiss, content: content))
    }
    
    func fullScreenCover<D: View>(isPublished: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> D) -> some View {
        self.modifier(FullScreenCoverPublishedModifier(published: isPublished, onDismiss: onDismiss, content: content))
    }
    
    func navigationDestination<D: View>(isPublished: Binding<Bool>, @ViewBuilder destination: @escaping () -> D) -> some View {
        self.modifier(NavigationDestinationPublishedModifier(published: isPublished, destination: destination))
    }
}

