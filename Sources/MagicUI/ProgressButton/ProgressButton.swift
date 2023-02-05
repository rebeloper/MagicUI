//
//  ProgressButton.swift
//  
//
//  Created by Alex Nagy on 04.02.2023.
//

import SwiftUI

public struct ProgressButton<S, L, P, B>: View where S: Shape, L: View, P: View, B: View {
    
    @State private var isInProgress = false
    
    var clipShape: S
    var fillStyle: FillStyle
    var direction: ProgressButtonDirection
    var action: (@escaping () -> ()) -> ()
    var progressState: (Bool) -> ()
    @ViewBuilder var label: () -> L
    @ViewBuilder var progress: () -> P
    @ViewBuilder var background: () -> B
    
    /// A button that has a progress animation when pressed
    /// - Parameters:
    ///   - direction: the direction of the animation, defaults to `.down`
    ///   - clipShape: the clipshape of the button, defaults to `Rectangle()`
    ///   - fillStyle: the fill sytyle of the clipShape, defaults to `FillStyle()`
    ///   - action: the action the button performs
    ///   - progressState: the progress state of the button
    ///   - label: the label of the button
    ///   - progress: the progress view to be shown when the button is tapped
    ///   - background: the background view of the button
    public init(direction: ProgressButtonDirection = .down,
                clipShape: S = Rectangle(),
                fillStyle: FillStyle = FillStyle(),
                action: @escaping (@escaping () -> Void) -> Void,
                progressState: @escaping (Bool) -> () = { _ in },
                @ViewBuilder label: @escaping () -> L,
                @ViewBuilder progress: @escaping () -> P,
                @ViewBuilder background: @escaping () -> B) {
        self.direction = direction
        self.clipShape = clipShape
        self.fillStyle = fillStyle
        self.action = action
        self.progressState = progressState
        self.label = label
        self.progress = progress
        self.background = background
    }
    
    @State private var size: CGSize = .zero
    
    public var body: some View {
        ZStack {
            progress()
                .offset(progressOffset())
            label()
                .offset(labelOffset())
        }
        .background {
            background()
        }
        .readSize(onChange: { size in
            self.size = size
        })
        .clipShape(clipShape, style: fillStyle)
        .onTapGesture {
            guard !isInProgress else { return }
            withAnimation {
                isInProgress.toggle()
            }
            action {
                withAnimation {
                    isInProgress.toggle()
                }
            }
        }
        .onChange(of: isInProgress) { newValue in
            progressState(newValue)
        }
    }
    
    func progressOffset() -> CGSize {
        switch direction {
        case .left:
            return CGSize(width: isInProgress ? 0 : size.width, height: 0)
        case .right:
            return CGSize(width: isInProgress ? 0 : -size.width, height: 0)
        case .up:
            return CGSize(width: 0, height: isInProgress ? 0 : size.width)
        case .down:
            return CGSize(width: 0, height: isInProgress ? 0 : -size.width)
        }
    }
    
    func labelOffset() -> CGSize {
        switch direction {
        case .left:
            return CGSize(width: isInProgress ? -size.width : 0, height: 0)
        case .right:
            return CGSize(width: isInProgress ? size.width : 0, height: 0)
        case .up:
            return CGSize(width: 0, height: isInProgress ? -size.width : 0)
        case .down:
            return CGSize(width: 0, height: isInProgress ? size.width : 0)
        }
    }
}

public enum ProgressButtonDirection: String, CaseIterable, Identifiable {
    case left, right, up, down
    
    public var id: String { self.rawValue }
}

//public extension View {
//
//    /// Reads the size of the View
//    /// - Parameter onChange: callback with the View size
//    /// - Returns: a View
//    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
//        background(
//            GeometryReader { geometryProxy in
//                Color.clear
//                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
//            }
//        )
//        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
//    }
//}
//
//private struct SizePreferenceKey: PreferenceKey {
//    static var defaultValue: CGSize = .zero
//    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
//}

