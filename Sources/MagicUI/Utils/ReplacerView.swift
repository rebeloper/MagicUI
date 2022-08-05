//
//  ReplacerView.swift
//  
//
//  Created by Alex Nagy on 05.08.2022.
//

import SwiftUI

public struct ReplacerView<O: View, N: View>: View {
    
    @State private var size: CGSize = .zero
    
    @ViewBuilder public let oldView: () -> O
    @ViewBuilder public let newView: () -> N
    
    public init(@ViewBuilder _ oldView: @escaping () -> O,
         @ViewBuilder newView: @escaping () -> N) {
        self.oldView = oldView
        self.newView = newView
    }
    
    public var body: some View {
        ZStack {
            oldView()
                .hidden()
                .frame(width: size.width, height: size.height)
            newView()
                .readSize { size in
                    self.size = size
                }
        }
    }
}

public extension View {
    func replaceWith<C: View>(@ViewBuilder content: @escaping () -> C) -> some View {
        ReplacerView {
            self
        } newView: {
            content()
        }
    }
}
