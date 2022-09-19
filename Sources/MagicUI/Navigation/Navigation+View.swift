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
    func sheet<D: View>(isActive: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> D) -> some View {
        self.modifier(SheetPublishedModifier(published: isActive, onDismiss: onDismiss, content: content))
    }
    
    @ViewBuilder
    func fullScreenCover<D: View>(isActive: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> D) -> some View {
        self.modifier(FullScreenCoverPublishedModifier(published: isActive, onDismiss: onDismiss, content: content))
    }
    
    @ViewBuilder
    func navigationDestination<D: View>(isActive: Binding<Bool>, @ViewBuilder destination: @escaping () -> D) -> some View {
        self.modifier(NavigationDestinationPublishedModifier(published: isActive, destination: destination))
    }
    
}

