//
//  PocketContent.swift
//
//  Created by Alex Nagy on 17.01.2023.
//

import SwiftUI

struct PocketContent<Data, Content: View>: View {
    
    @Binding var selection: Int
    var data: [Data]
    @ViewBuilder var content: (Int) -> Content
    
    var body: some View {
        ZStack {
            ForEach(data.indices, id: \.self) { index in
                content(index).opacity(selection == index ? 1 : 0)
            }
        }
    }
}

