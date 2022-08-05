//
//  ActiveText.swift
//  
//
//  Created by Alex Nagy on 05.08.2022.
//

import SwiftUI

public struct ActiveText<Content: View>: View {
    
    public typealias ActiveTextResult = (word: String, text: Text)
    
    @Binding var content: String
    let lineOffset: CGFloat
    let alignment: HorizontalAlignment
    @ViewBuilder let transform: (ActiveTextResult) -> Content
    
    public init(_ content: Binding<String>,
                lineOffset: CGFloat = 0,
                alignment: HorizontalAlignment = .leading,
                @ViewBuilder transform: @escaping (ActiveTextResult) -> Content) {
        self._content = content
        self.lineOffset = lineOffset
        self.alignment = alignment
        self.transform = transform
    }
    
    @State private var data: [String] = []
    
    public var body: some View {
        FlowView(data, vSpacing: lineOffset, hSpacing: 0, alignment: alignment) { string in
            return Text(word(for: string))
                .getView { text in
                    transform((string, text))
                }
        }
        .onAppear {
            data = content.components(separatedBy: " ")
        }
        .onChange(of: content) { newValue in
            data = content.components(separatedBy: " ")
        }
    }
    
    func word(for string: String) -> String {
        "\(string)\((data.last ?? "") != string ? " " : "")"
    }
}

public extension Text {
    @ViewBuilder
    func getView<Content: View>(_ transform: (Self) -> Content) -> some View {
        transform(self)
    }
}

