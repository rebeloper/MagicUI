//
//  Dismissable.swift
//  
//
//  Created by Alex Nagy on 18.09.2022.
//

import SwiftUI

public struct Dismissable: ViewModifier {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding public var isActive: Bool
    
    public func body(content: Content) -> some View {
        content
            .onChange(of: isActive) { isActive in
                if !isActive {
                    dismiss()
                }
            }
    }
}

public extension View {
    func setAsNavigationDestination(_ navigationDestination: Binding<Bool>) -> some View {
        self.modifier(Dismissable(isActive: navigationDestination))
    }
}
