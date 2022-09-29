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
    
    /// Presents a modal view that covers as much of the screen as
    /// possible when binding to a Boolean value you provide is true.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the sheet.
    ///   - router: A navigation router.
    ///   - routes: Navigation routes.
    ///   - presentationDetents: A set of supported detents for the sheet.
    ///   - visibility: The preferred visibility of the drag indicator.
    ///   - data: The type of data that the destination matches.
    ///   - destination: A view to present.
    ///   - root: A closure that returns the content of the modal view.
    ///   - onDismiss: The closure to execute when dismissing the modal view.
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
    
    /// Presents a sheet when a binding or @Published to a Boolean value that you
    /// provide is true. Use this method when you want to present a modal view to the
    /// user when a Boolean value you provide is true.
    ///
    /// - Parameters:
    ///   - isActive: A binding or @Published to a Boolean value that determines whether
    ///     to present the sheet that you create in the modifier's
    ///     `content` closure.
    ///   - onDismiss: The closure to execute when dismissing the sheet.
    ///   - content: A closure that returns the content of the sheet.
    @ViewBuilder
    func sheet<D: View>(isActive: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> D) -> some View {
        self.modifier(SheetPublishedModifier(published: isActive, onDismiss: onDismiss, content: content))
    }
    
    
    /// Presents a modal view that covers as much of the screen as
    /// possible when binding to a Boolean value you provide is true.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the sheet.
    ///   - router: A navigation router.
    ///   - routes: Navigation routes.
    ///   - data: The type of data that the destination matches.
    ///   - destination: A view to present.
    ///   - root: A closure that returns the content of the modal view.
    ///   - onDismiss: The closure to execute when dismissing the modal view.
    func fullScreenCover<D: Hashable, C: View, Root: View>(isPresented: Binding<Bool>,
                                                           router: Router,
                                                           routes: RoutesObject,
                                                           for data: D.Type,
                                                           @ViewBuilder destination: @escaping (D) -> C,
                                                           @ViewBuilder root: @escaping () -> Root,
                                                           onDismiss: (() -> Void)? = nil) -> some View {
        self.modifier(FullScreenCoverRouterModifier(isPresented: isPresented, router: router, routes: routes, for: data, destination, root: root, onDismiss: onDismiss))
    }
    
    /// Presents a full screen cover when a binding or @Published to a Boolean value that you
    /// provide is true. Use this method to show a modal view that covers as much of the screen
    /// as possible.
    ///
    /// - Parameters:
    ///   - isActive: A binding or @Published to a Boolean value that determines whether
    ///     to present the full screen cover that you create in the modifier's
    ///     `content` closure.
    ///   - onDismiss: The closure to execute when dismissing the modal view.
    ///   - content: A closure that returns the content of the modal view.
    @ViewBuilder
    func fullScreenCover<D: View>(isActive: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> D) -> some View {
        self.modifier(FullScreenCoverPublishedModifier(published: isActive, onDismiss: onDismiss, content: content))
    }
}
