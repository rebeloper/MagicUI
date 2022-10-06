//
//  FullScreenCoverPublishedModifier.swift
//  
//
//  Created by Alex Nagy on 06.10.2022.
//

import SwiftUI

internal struct FullScreenCoverPublishedModifier<D: View>: ViewModifier {
    
    @State private var binding = false
    
    @Binding internal var published: Bool
    internal var onDismiss: (() -> Void)?
    @ViewBuilder internal var destination: () -> D
    
    internal init(published: Binding<Bool>,
                  onDismiss: (() -> Void)? = nil,
                  content: @escaping () -> D) {
        self._published = published
        self.onDismiss = onDismiss
        self.destination = content
    }
    
    internal func body(content: Content) -> some View {
        content
            .sync($published, with: $binding)
            .fullScreenCover(isPresented: $binding, onDismiss: onDismiss, content: destination)
    }
}
