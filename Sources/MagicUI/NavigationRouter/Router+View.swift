//
//  Router+View.swift
//  
//
//  Created by Alex Nagy on 28.09.2022.
//

import SwiftUI

public extension View {
    
    internal func sync<T: Equatable>(_ published: Binding<T>, with binding: Binding<T>) -> some View {
        self
            .onChange(of: published.wrappedValue) { published in
                binding.wrappedValue = published
            }
            .onChange(of: binding.wrappedValue) { binding in
                published.wrappedValue = binding
            }
    }
    
    func sheet<D: Hashable, C: View, Root: View>(isPresented: Binding<Bool>,
                                                 router: Router,
                                                 routes: RoutesObject,
                                                 presentationDetents: Set<PresentationDetent> = [],
                                                 presentationDragIndicator visibility: Visibility = .automatic,
                                                 for data: D.Type,
                                                 @ViewBuilder destination: @escaping (D) -> C,
                                                 @ViewBuilder root: @escaping () -> Root,
                                                 onDismiss: (() -> Void)? = nil) -> some View {
        self.modifier(SheetRouterModifier(isPresented: isPresented, router: router, routes: routes, presentationDetents: presentationDetents, presentationDragIndicator: visibility, for: data, destination, root: root, onDismiss: onDismiss))
    }
    
    @ViewBuilder
    func sheet<D: View>(isActive: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> D) -> some View {
        self.modifier(SheetPublishedModifier(published: isActive, onDismiss: onDismiss, content: content))
    }
    
    func fullScreenCover<D: Hashable, C: View, Root: View>(isPresented: Binding<Bool>,
                                                           router: Router,
                                                           routes: RoutesObject,
                                                           for data: D.Type,
                                                           @ViewBuilder destination: @escaping (D) -> C,
                                                           @ViewBuilder root: @escaping () -> Root,
                                                           onDismiss: (() -> Void)? = nil) -> some View {
        self.modifier(FullScreenCoverRouterModifier(isPresented: isPresented, router: router, routes: routes, for: data, destination, root: root, onDismiss: onDismiss))
    }
    
    @ViewBuilder
    func fullScreenCover<D: View>(isActive: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> D) -> some View {
        self.modifier(FullScreenCoverPublishedModifier(published: isActive, onDismiss: onDismiss, content: content))
    }
}
