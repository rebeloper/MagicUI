//
//  PocketView.swift
//
//  Created by Alex Nagy on 10.01.2023.
//

import SwiftUI

public struct PocketView<Header: View, Content: View>: View {
    
    @Binding var selection: Int
    var alignment: PocketViewHeaderAlignment
    
    @ViewBuilder var header: () -> Header
    @ViewBuilder var content: () -> Content
    
    public init(_ selection: Binding<Int>, alignment: PocketViewHeaderAlignment = .top, @ViewBuilder header: @escaping () -> Header, @ViewBuilder content: @escaping () -> Content) {
        self._selection = selection
        self.alignment = alignment
        self.header = header
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            switch alignment {
            case .bottom:
                ZStack {
                    content()
                }
                Divider()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        header()
                    }
                }
            case .top:
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        header()
                    }
                }
                Divider()
                ZStack {
                    content()
                }
            }
            
        }
    }
}
