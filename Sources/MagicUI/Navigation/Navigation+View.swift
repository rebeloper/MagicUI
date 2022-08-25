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
    
    /// Associates a destination view with a binding that can be used to:
    /// - push the view onto a ``NavigationStack``,
    /// - present a sheet / full screen cover when a binding to a Boolean value that you
    /// provide is true.
    ///
    /// When ``type`` is ``stack`` add this view modifer to a view inside a
    /// ``NavigationStack`` to programmatically push a single view onto the stack.
    /// This is useful for building components that can push an associated view.
    ///
    /// Do not put a navigation destination modifier inside a "lazy" container,
    /// like ``List`` or ``LazyVStack``. These containers create child views
    /// only when needed to render on screen. Add the navigation destination
    /// modifier outside these containers so that the navigation stack can
    /// always see the destination.
    ///
    /// Use this method with ``type`` ``sheet`` or ``fullScreenCover``
    /// when you want to present a modal view to the user when a Boolean value
    /// you provide is true.
    ///
    /// - Parameters:
    ///   - type: the navigation type: ``stack``, ``sheet`` or ``fullScreenCover``
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the view that you create in the modifier's
    ///     `destination` closure.
    ///   - destination: A closure that returns the content of the sheet.
    ///   - onDismiss: The closure to execute when dismissing the sheet.
    @ViewBuilder
    func navigationDestination<D: View>(_ type: NavigationType, isPresented: Binding<Bool>, @ViewBuilder destination: @escaping () -> D, onDismiss: (() -> Void)? = nil) -> some View {
        switch type {
        case .stack:
            self.navigationDestination(isPresented: isPresented, destination: destination)
        case .sheet:
            self.sheet(isPresented: isPresented, onDismiss: onDismiss, content: destination)
        case .fullScreenCover:
            self.fullScreenCover(isPresented: isPresented, onDismiss: onDismiss, content: destination)
        }
    }
    
    /// Associates a binding that can trigger a pop to a pop destination
    /// - Parameters:
    ///   - isActive: A binding to a Boolean value that determines whether
    ///     to activate the view to pop itself and its predecesors till we
    ///     reach the view associated with the ``popDestination``
    ///   - popDestination: A binding to a Boolean value that determines
    ///   the pop destination
    func pop(isActive: Binding<Bool>, popDestination: Binding<Bool>) -> some View {
        self.onAppear {
            popDestination.wrappedValue = false
        }.onDisappear {
            if isActive.wrappedValue {
                popDestination.wrappedValue = true
            }
        }
    }
    
    /// Sets the view as popable by a pop destination
    /// - Parameters:
    ///   - type: the navigation type: ``stack``, ``sheet`` or ``fullScreenCover``
    ///   - popDestination: A binding to a Boolean value that determines
    ///   the pop destination
    ///   - isPresented: A binding to a Boolean value that determines
    ///   the current / popped view's presented state
    ///   - dismiss: ``DismissAction`` associated with the current view
    func popable(_ type: NavigationType, byPopDestination popDestination: Binding<Bool>, isPresented: Binding<Bool>, dismiss: DismissAction) -> some View {
        self.onChange(of: isPresented.wrappedValue) { newValue in
            if type == .stack {
                if !newValue, popDestination.wrappedValue {
                    dismiss()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                    if !newValue, popDestination.wrappedValue {
                        dismiss()
                    }
                })
            }
        }
    }
}

