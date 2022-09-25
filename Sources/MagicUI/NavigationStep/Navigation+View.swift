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
    
    /// Sets a destination view for a ``NavigationStep``
    /// - Parameters:
    ///   - type: the type of navigation
    ///   - step: the ``NavigationStep``
    ///   - destination: A closure that returns the destination view of the ``NavigationStep``
    ///   - onDismiss: The closure to execute when dismissing the sheet / full screen cover type of ``NavigationStep``.
    @ViewBuilder
    func navigationDestination<D: View>(type: NavigationType, for step: Binding<NavigationStep>, @ViewBuilder destination: @escaping () -> D) -> some View {
        switch type {
        case .stack:
            self.navigationDestination(isActive: step.isActive, destination: destination)
        case .sheet(let onDismiss):
            self.sheet(isActive: step.isActive, onDismiss: onDismiss, content: destination)
        case .fullScreenCover(let onDismiss):
            self.fullScreenCover(isActive: step.isActive, onDismiss: onDismiss, content: destination)
        }
    }
    
    internal func sync<T: Equatable>(_ published: Binding<T>, with binding: Binding<T>) -> some View {
        self
            .onChange(of: published.wrappedValue) { published in
                binding.wrappedValue = published
            }
            .onChange(of: binding.wrappedValue) { binding in
                published.wrappedValue = binding
            }
    }
    
    /// Associates a destination view with a binding or publisher that can be used to push
    /// the view onto a ``NavigationStack``.
    ///
    /// In general, favor binding a path to a navigation stack for programmatic
    /// navigation. Add this view modifer to a view inside a ``NavigationStack``
    /// to programmatically push a single view onto the stack. This is useful
    /// for building components that can push an associated view. For example,
    /// you can present a `ColorDetail` view for a particular color:
    ///
    ///     @State private var showDetails = false
    ///     var favoriteColor: Color
    ///
    ///     NavigationStack {
    ///         VStack {
    ///             Circle()
    ///                 .fill(favoriteColor)
    ///             Button("Show details") {
    ///                 showDetails = true
    ///             }
    ///         }
    ///         .navigationDestination(isPresented: $showDetails) {
    ///             ColorDetail(color: favoriteColor)
    ///         }
    ///         .navigationTitle("My Favorite Color")
    ///     }
    ///
    /// Do not put a navigation destination modifier inside a "lazy" container,
    /// like ``List`` or ``LazyVStack``. These containers create child views
    /// only when needed to render on screen. Add the navigation destination
    /// modifier outside these containers so that the navigation stack can
    /// always see the destination.
    ///
    /// - Parameters:
    ///   - isActive: A binding or publisher to a Boolean value that indicates whether
    ///     `destination` is currently presented.
    ///   - destination: A view to present.
    @ViewBuilder
    func navigationDestination<D: View>(isActive: Binding<Bool>, @ViewBuilder destination: @escaping () -> D) -> some View {
        self.modifier(NavigationDestinationPublishedModifier(published: isActive, destination: destination))
    }
    
    /// Presents a sheet when a binding or publisher to a Boolean value that you
    /// provide is true.
    ///
    /// Use this method when you want to present a modal view to the
    /// user when a Boolean value you provide is true. The example
    /// below displays a modal view of the mockup for a software license
    /// agreement when the user toggles the `isShowingSheet` variable by
    /// clicking or tapping on the "Show License Agreement" button:
    ///
    ///     struct ShowLicenseAgreement: View {
    ///         @State private var isShowingSheet = false
    ///         var body: some View {
    ///             Button(action: {
    ///                 isShowingSheet.toggle()
    ///             }) {
    ///                 Text("Show License Agreement")
    ///             }
    ///             .sheet(isPresented: $isShowingSheet,
    ///                    onDismiss: didDismiss) {
    ///                 VStack {
    ///                     Text("License Agreement")
    ///                         .font(.title)
    ///                         .padding(50)
    ///                     Text("""
    ///                             Terms and conditions go here.
    ///                         """)
    ///                         .padding(50)
    ///                     Button("Dismiss",
    ///                            action: { isShowingSheet.toggle() })
    ///                 }
    ///             }
    ///         }
    ///
    ///         func didDismiss() {
    ///             // Handle the dismissing action.
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - isActive: A binding or publisher to a Boolean value that determines whether
    ///     to present the sheet that you create in the modifier's
    ///     `content` closure.
    ///   - onDismiss: The closure to execute when dismissing the sheet.
    ///   - content: A closure that returns the content of the sheet.
    @ViewBuilder
    func sheet<D: View>(isActive: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> D) -> some View {
        self.modifier(SheetPublishedModifier(published: isActive, onDismiss: onDismiss, content: content))
    }
    
    /// Presents a modal view that covers as much of the screen as
    /// possible when a binding or publisher to a Boolean value that you
    /// provide is true.
    ///
    /// Use this method to show a modal view that covers as much of the screen
    /// as possible. The example below displays a custom view when the user
    /// toggles the value of the `isPresenting` binding:
    ///
    ///     struct FullScreenCoverPresentedOnDismiss: View {
    ///         @State private var isPresenting = false
    ///         var body: some View {
    ///             Button("Present Full-Screen Cover") {
    ///                 isPresenting.toggle()
    ///             }
    ///             .fullScreenCover(isPresented: $isPresenting,
    ///                              onDismiss: didDismiss) {
    ///                 VStack {
    ///                     Text("A full-screen modal view.")
    ///                         .font(.title)
    ///                     Text("Tap to Dismiss")
    ///                 }
    ///                 .onTapGesture {
    ///                     isPresenting.toggle()
    ///                 }
    ///                 .foregroundColor(.white)
    ///                 .frame(maxWidth: .infinity,
    ///                        maxHeight: .infinity)
    ///                 .background(Color.blue)
    ///                 .ignoresSafeArea(edges: .all)
    ///             }
    ///         }
    ///
    ///         func didDismiss() {
    ///             // Handle the dismissing action.
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - isActive: A binding or publisher to a Boolean value that determines whether
    ///     to present the modal view.
    ///   - onDismiss: The closure to execute when dismissing the modal view.
    ///   - content: A closure that returns the content of the modal view.
    @ViewBuilder
    func fullScreenCover<D: View>(isActive: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> D) -> some View {
        self.modifier(FullScreenCoverPublishedModifier(published: isActive, onDismiss: onDismiss, content: content))
    }
    
}

