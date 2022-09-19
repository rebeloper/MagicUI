//
//  Dismissable.swift
//  
//
//  Created by Alex Nagy on 18.09.2022.
//

import SwiftUI

public struct Dismissable: ViewModifier {
    
    @Environment(\.dismiss) private var dismiss
    
    public var isDismissed: Published<Bool>.Publisher
    
    public func body(content: Content) -> some View {
        content
            .onReceive(isDismissed) { shouldDismiss in
                if shouldDismiss {
                    dismiss()
                }
            }
    }
}

public extension View {
    func dismissable(_ isDismissed: Published<Bool>.Publisher) -> some View {
        self.modifier(Dismissable(isDismissed: isDismissed))
    }
}
