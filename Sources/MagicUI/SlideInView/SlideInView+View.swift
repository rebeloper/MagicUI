//
//  SlideInView+View.swift
//  
//
//  Created by Alex Nagy on 24.01.2023.
//

#if !os(tvOS)
import SwiftUI

public extension View {
    
    
    func slideInView<Content: View>(_ edge: Edge = .leading, paddingPercentage: CGFloat = 0.3, options: SlideInViewOptions = SlideInViewOptions(), content: @escaping () -> Content) -> some View {
        SlideInView(edge, paddingPercentage: paddingPercentage, options: options, content: content) {
            self
        }
    }
    
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
//    @ViewBuilder
//    func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
//        if condition() {
//            transform(self)
//        } else {
//            self
//        }
//    }
}
#endif
