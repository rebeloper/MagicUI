//
//  FlexibleSheetModifier.swift
//  NavigationStep
//
//  Created by Alex Nagy on 08.08.2022.
//

import SwiftUI

internal struct FlexibleSheetModifier: ViewModifier {
    
    @State private var destinationSize: CGSize = .zero
    
    internal func body(content: Content) -> some View {
        content
            .readSize { size in
                destinationSize = size
            }
            .presentationDetents([.height(destinationSize.height)])
    }
}

public extension View {
    
    /// Sets the ``sheet``'s height from the content's heigh
    /// Make sure you're using this on ``pull-in`` views. If you're
    /// using it on ``push-out`` views like ``List``, ``VStack`` etc.
    /// make sure to give the view a frame that the ``felxible sheet``
    /// can use to lay out it's content
    func flexibleSheet() -> some View {
        modifier(FlexibleSheetModifier())
    }
}
