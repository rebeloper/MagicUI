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
    
    /// Creates a navigation stack with heterogeneous navigation state that you
    /// can control. Associates a destination view with a presented data type for use within
    /// a navigation stack.
    ///
    /// - Parameters:
    ///   - data: The type of data that this destination matches.
    ///   - destination: A view builder that defines a view to display
    ///     when the stack's navigation state contains a value of
    ///     type `data`. The closure takes one argument, which is the value
    ///     of the data to present.
    func rootNavigationStack<D: Hashable, C: View>(for data: D.Type, @ViewBuilder _ destination: @escaping (D) -> C) -> some View {
        RootNavigationStack(for: data, destination) {
            self
        }
    }
    
    /// Presents a modal view with a NavigationStack that covers as much of the screen as
    /// possible when binding to a Boolean value you provide is true.
    ///
    /// - Parameters:
    ///   - isActive: A binding to a Boolean value that determines whether
    ///     to present the sheet.
    ///   - presentationDetents: A set of supported detents for the sheet.
    ///   - visibility: The preferred visibility of the drag indicator.
    ///   - data: The type of data that the destination matches.
    ///   - destination: A view to present.
    ///   - root: A closure that returns the content of the modal view.
    ///   - onDismiss: The closure to execute when dismissing the modal view.
    func sheetNavigationStack<D: Hashable, C: View, Root: View>(isActive: Binding<Bool>,
                                                                presentationDetents: Set<PresentationDetent> = [],
                                                                presentationDragIndicator visibility: Visibility = .automatic,
                                                                for data: D.Type,
                                                                @ViewBuilder destination: @escaping (D) -> C,
                                                                @ViewBuilder root: @escaping () -> Root,
                                                                onDismiss: (() -> Void)? = nil) -> some View {
        self.modifier(SheetNavigationStackModifier(isActive: isActive, presentationDetents: presentationDetents, presentationDragIndicator: visibility, for: data, destination, root: root, onDismiss: onDismiss))
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
    
    
    /// Presents a modal view with a NavigationStack that covers as much of the screen as
    /// possible when binding to a Boolean value you provide is true.
    ///
    /// - Parameters:
    ///   - isActive: A binding to a Boolean value that determines whether
    ///     to present the sheet.
    ///   - data: The type of data that the destination matches.
    ///   - destination: A view to present.
    ///   - root: A closure that returns the content of the modal view.
    ///   - onDismiss: The closure to execute when dismissing the modal view.
    func fullScreenCoverNavigationStack<D: Hashable, C: View, Root: View>(isActive: Binding<Bool>,
                                                                          for data: D.Type,
                                                                          @ViewBuilder destination: @escaping (D) -> C,
                                                                          @ViewBuilder root: @escaping () -> Root,
                                                                          onDismiss: (() -> Void)? = nil) -> some View {
        self.modifier(FullScreenCoverNavigationStackModifier(isActive: isActive, for: data, destination, root: root, onDismiss: onDismiss))
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
