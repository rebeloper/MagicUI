//
//  AsNavigationDestination.swift
//  
//
//  Created by Alex Nagy on 18.09.2022.
//

import SwiftUI

public struct AsNavigationDestination: ViewModifier {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding public var navigationDestination: Bool
    
    public func body(content: Content) -> some View {
        content
            .onChange(of: navigationDestination) { navigationDestination in
                if !navigationDestination {
                    dismiss()
                }
            }
    }
}

public extension View {
    func setAsNavigationDestination(_ navigationDestination: Binding<Bool>) -> some View {
        self.modifier(AsNavigationDestination(navigationDestination: navigationDestination))
    }
}
