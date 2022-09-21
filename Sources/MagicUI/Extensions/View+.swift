//
//  View+.swift
//  MagicUI
//
//  Created by Alex Nagy on 17.06.2022.
//

import SwiftUI
import Combine
import PhotosUI

public extension View {
    
    // Positions this view within an invisible frame with the specified size with a set .center alignment.
    /// - Parameter square: A fixed width and height for the resulting view. If `width` is `nil`, the resulting view assumes this view's sizing behavior.
    /// - Returns: A square view with fixed dimensions of `width` and `height`.
    func frame(square lenght: CGFloat?) -> some View {
        self.frame(width: lenght, height: lenght)
    }
    
    /// Hides / unhides a view
    /// - Parameter shouldHide: hidden value
    /// - Returns: a view that is hidden or not
    @ViewBuilder func isHidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
    
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder
    func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
    
    /// Clips this view to its bounding rectangular frame and defines the content shape for hit testing.
    /// - Parameters:
    ///   - cornerRadius: corner radius. Default is 0
    ///   - style: rounded corner style. Default is .circular
    func clippedContent(cornerRadius: CGFloat = 0, style: RoundedCornerStyle = .circular) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: style))
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: style))
    }
    
    /// Creates a `Push Out View` from a `Pull In View`
    /// - Parameter backgroundColor: The color of the area outside of the `Pull In View`
    /// - Returns: a `Push Out View`
    func asPushOutView(_ backgroundColor: Color = .clear) -> some View {
        ZStack {
            backgroundColor
            self
        }
    }
    
    @ViewBuilder
    /// Can create a `Push Out View` from a
    /// - Parameters:
    ///   - isPushOutView: should create a `Push Out View` from a `Pull In View`
    ///   - backgroundColor: The color of the area outside of the `Pull In View`
    /// - Returns: a `Push Out View` or a `Pull In View`
    func isPushOutView(_ isPushOutView: Bool = true, backgroundColor: Color = .clear) -> some View {
        if isPushOutView {
            ZStack {
                backgroundColor
                self
            }
        } else {
            self
        }
    }
    
    /// Links a ``PhotosPicker`` selection to a ``UIImage`` binding
    /// - Parameters:
    ///   - selection: ``PhotosPicker`` selection
    ///   - selectedUIImage: ``UIImage`` binding
    @MainActor
    func linkPhotosPicker(selection: Binding<PhotosPickerItem?>, toSelectedUIImage selectedUIImage: Binding<UIImage?>) -> some View {
        self.onChange(of: selection.wrappedValue) { newValue in
            Task {
                if let imageData = try? await newValue?.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                    selectedUIImage.wrappedValue = image
                }
            }
        }
    }
}
