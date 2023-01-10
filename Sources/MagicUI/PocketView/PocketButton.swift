//
//  PocketButton.swift
//
//  Created by Alex Nagy on 10.01.2023.
//

import SwiftUI

public struct PocketButton<Label: View>: View {
    
    @Binding var selection: Int
    var index: Int
    
    @ViewBuilder var label: () -> Label
    
    public init(_ selection: Binding<Int>, index: Int, @ViewBuilder label: @escaping () -> Label) {
        self._selection = selection
        self.index = index
        self.label = label
    }
    
    public var body: some View {
        Button {
            selection = index
        } label: {
            label()
        }
    }
}
