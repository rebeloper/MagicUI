//
//  AsNavigationDestination.swift
//  
//
//  Created by Alex Nagy on 18.09.2022.
//

import SwiftUI

public struct AsNavigationDestination: ViewModifier {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding public var navigationDestination: NavigationDestination
    
    public func body(content: Content) -> some View {
        content
            .onChange(of: navigationDestination.isActive) { isActive in
                if !isActive {
                    dismiss()
                }
            }
    }
}

public extension View {
    func setAsNavigationDestination(_ navigationDestination: Binding<NavigationDestination>) -> some View {
        self.modifier(AsNavigationDestination(navigationDestination: navigationDestination))
    }
}
