//
//  PocketButton.swift
//
//  Created by Alex Nagy on 17.01.2023.
//

import SwiftUI

struct PocketToolbarItem<Data, Label: View>: View {
    
    @Binding var selection: Int
    var data: [Data]
    @ViewBuilder var label: (Int) -> Label
    
    var body: some View {
        ForEach(data.indices, id: \.self) { index in
            Button {
                selection = index
            } label: {
                label(index)
            }
        }
    }
}
