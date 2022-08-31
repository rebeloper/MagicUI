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
            self.navigationDestination(isPresented: push.isActive, destination: destination)
        case .sheet:
            self.sheet(isPresented: push.isActive, onDismiss: onDismiss, content: destination)
        case .fullScreenCover:
            self.fullScreenCover(isPresented: push.isActive, onDismiss: onDismiss, content: destination)
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
}

