//
//  NavigationModifier.swift
//  StringNavigation
//
//  Created by Alex Nagy on 08.08.2022.
//

import SwiftUI

public struct NavigationModifier<D>: ViewModifier where D: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var isStacked = false
    @State private var isPresented = false
    @State private var isCovered = false
    
    let type: NavigationType
    @Binding var isActive: Bool
    let onDismiss: (() -> Void)?
    @ViewBuilder let destination: () -> D
    
    public func body(content: Content) -> some View {
        content
            .navigationDestination(isPresented: $isStacked) {
                destination()
            }
            .sheet(isPresented: $isPresented, onDismiss: onDismiss) {
                destination()
            }
            .fullScreenCover(isPresented: $isCovered, onDismiss: onDismiss) {
                destination()
            }
            .onChange(of: isActive) { isActive in
                if isActive {
                    switch type {
                    case .stack:
                        isStacked = isActive
                    case .sheet:
                        isPresented = isActive
                    case .cover:
                        isCovered = isActive
                    }
                } else {
                    if Navigation.popsToRoot {
                        DispatchQueue.main.asyncAfter(deadline: .now() + (type == .stack ? 0 : 0.6), execute: {
                            self.dismiss()
                        })
                    } else {
                        if Navigation.popsToLast {
                            if Navigation.last > 0 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + (type == .stack ? 0 : 0.6), execute: {
                                    self.dismiss()
                                    Navigation.last -= 1
                                })
                            } else {
                                Navigation.popsToRoot = false
                                Navigation.popsToLast = false
                            }
                        }
                    }
                }
            }
            .onChange(of: isStacked) { value in
                if type == .stack, isActive {
                    isActive = value
                }
            }
            .onChange(of: isPresented) { value in
                if type == .sheet, isActive {
                    isActive = value
                }
            }
            .onChange(of: isCovered) { value in
                if type == .cover, isActive {
                    isActive = value
                }
            }
    }
}

public extension View {
    
    /// Sets up a ``Navigation Step``
    /// - Parameters:
    ///   - step: a ``Bool Binding`` representing a ``Navigation Step``
    ///   - type: the type of the ``Navigation Step``
    ///   - onDismiss: callback for when the ``Navigation Step`` is dismissed
    ///   - destinationView: the destination of the ``Navigation Step``
    func navigation<D: View>(step: Binding<Bool>, type: NavigationType, onDismiss: (() -> Void)? = nil, @ViewBuilder destinationView: @escaping () -> D) -> some View {
        self.modifier(NavigationModifier(type: type, isActive: step, onDismiss: onDismiss, destination: destinationView))
    }
}
