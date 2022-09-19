//
//  NavigatioPublishedModifiers.swift
//  
//
//  Created by Alex Nagy on 16.09.2022.
//

import SwiftUI

public struct SheetPublishedModifier<D: View>: ViewModifier {
    
    @State private var binding = false
    
    @Binding public var published: Bool
    public var onDismiss: (() -> Void)?
    @ViewBuilder public var destination: () -> D
    
    public init(published: Binding<Bool>,
                onDismiss: (() -> Void)? = nil,
                content: @escaping () -> D) {
        self._published = published
        self.onDismiss = onDismiss
        self.destination = content
    }
    
    public func body(content: Content) -> some View {
        content
            .sync($published, with: $binding)
            .sheet(isPresented: $binding, onDismiss: onDismiss, content: destination)
    }
}

public struct FullScreenCoverPublishedModifier<D: View>: ViewModifier {
    
    @State private var binding = false
    
    @Binding public var published: Bool
    public var onDismiss: (() -> Void)?
    @ViewBuilder public var destination: () -> D
    
    public init(published: Binding<Bool>,
                onDismiss: (() -> Void)? = nil,
                content: @escaping () -> D) {
        self._published = published
        self.onDismiss = onDismiss
        self.destination = content
    }
    
    public func body(content: Content) -> some View {
        content
            .sync($published, with: $binding)
            .fullScreenCover(isPresented: $binding, onDismiss: onDismiss, content: destination)
    }
}

public struct NavigationDestinationPublishedModifier<D: View>: ViewModifier {
    
    @State private var binding = false
    
    @Binding public var published: Bool
    @ViewBuilder public var destination: () -> D
    
    public init(published: Binding<Bool>,
                destination: @escaping () -> D) {
        self._published = published
        self.destination = destination
    }
    
    public func body(content: Content) -> some View {
        content
            .sync($published, with: $binding)
            .navigationDestination(isPresented: $binding, destination: destination)
    }
}