//
//  PocketView.swift
//
//  Created by Alex Nagy on 17.01.2023.
//

import SwiftUI

public struct PocketView<Data, ToolbarItem: View, Content: View>: View {
    
    @Binding public var selection: Int
    public var data: [Data]
    public var alignment: PocketViewToolbarAlignment
    @ViewBuilder public var toolbarItem: (Int) -> ToolbarItem
    @ViewBuilder public var content: (Int) -> Content
    
    public init(_ selection: Binding<Int>, data: [Data], alignment: PocketViewToolbarAlignment = .top, toolbarItem: @escaping (Int) -> ToolbarItem, content: @escaping (Int) -> Content) {
        self._selection = selection
        self.data = data
        self.alignment = alignment
        self.toolbarItem = toolbarItem
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            switch alignment {
            case .top:
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        PocketToolbarItem(selection: $selection, data: data) { index in
                            toolbarItem(index)
                        }
                    }
                }
                ZStack {
                    PocketContent(selection: $selection, data: data) { index in
                        content(index)
                    }
                    
                }
            case .bottom:
                ZStack {
                    PocketContent(selection: $selection, data: data) { index in
                        content(index)
                    }
                    
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        PocketToolbarItem(selection: $selection, data: data) { index in
                            toolbarItem(index)
                        }
                    }
                }
            }
            
        }
    }
}

