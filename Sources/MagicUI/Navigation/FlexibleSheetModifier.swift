//
//  FlexibleSheetModifier.swift
//  StringNavigation
//
//  Created by Alex Nagy on 08.08.2022.
//

import SwiftUI

public struct FlexibleSheetModifier: ViewModifier {
    
    @State private var destinationSize: CGSize = .zero
    
    public func body(content: Content) -> some View {
        content
            .readSize { size in
                destinationSize = size
            }
            .presentationDetents([.height(destinationSize.height)])
    }
}

public extension View {
    func flexibleSheet() -> some View {
        modifier(FlexibleSheetModifier())
    }
}
