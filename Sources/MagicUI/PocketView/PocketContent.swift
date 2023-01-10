//
//  PocketContent.swift
//
//  Created by Alex Nagy on 10.01.2023.
//

import SwiftUI

public struct PocketContent<Content: View>: View {
    
    @Binding var selection: Int
    var index: Int
    
    @ViewBuilder var content: () -> Content
    
    public init(_ selection: Binding<Int>, index: Int, @ViewBuilder content: @escaping () -> Content) {
        self._selection = selection
        self.index = index
        self.content = content
    }
    
    public var body: some View {
        content().opacity(selection == index ? 1 : 0)
    }
}
