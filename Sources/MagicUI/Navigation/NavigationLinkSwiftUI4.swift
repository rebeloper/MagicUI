//
//  NavigationLinkSwiftUI4.swift
//  MagicUI
//
//  Created by Alex Nagy on 01.08.2022.
//

import SwiftUI

@available(iOS 16.0, *)
@available(macOS 13.0, *)
@available(tvOS 16.0, *)
@available(watchOS 9.0, *)
public struct NavigationLinkSwiftUI4<L: View, D: View>: View {
    
    @Binding public var isActive: Bool
    @ViewBuilder public let destination: () -> D
    @ViewBuilder public let label: () -> L
    
    public init(isActive: Binding<Bool>, @ViewBuilder destination: @escaping () -> D, @ViewBuilder label: @escaping () -> L) {
        self._isActive = isActive
        self.destination = destination
        self.label = label
    }
    
    public var body: some View {
        Button {
            isActive.toggle()
        } label: {
            label()
        }
        .navigationDestination(isPresented: $isActive) {
            destination()
        }
    }
}
