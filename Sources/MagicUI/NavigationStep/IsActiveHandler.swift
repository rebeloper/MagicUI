//
//  IsActiveHandler.swift
//  
//
//  Created by Alex Nagy on 20.09.2022.
//

import SwiftUI

internal struct IsActiveHandler: ViewModifier {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding internal var isActive: Bool
    
    internal func body(content: Content) -> some View {
        content
            .onChange(of: isActive) { isActive in
                if !isActive {
                    dismiss()
                }
            }
    }
}

public extension View {
    
    /// Sets a binding or publisher to a Boolean value that determines whether
    ///     this view is presented.
    /// - Parameter isActive: A binding or publisher to a Boolean value that determines whether
    ///     this view is presented.
    func isActiveHandler(_ isActive: Binding<Bool>) -> some View {
        self.modifier(IsActiveHandler(isActive: isActive))
    }
}
