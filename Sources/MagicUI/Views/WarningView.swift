//
//  WarningView.swift
//  MagicUI
//
//  Created by Alex Nagy on 17.06.2022.
//

import SwiftUI

struct WarningView: View {
    
    let item: WarningViewItem
    
    var body: some View {
        VStack(spacing: 9) {
            Image(systemName: item.iconSystemName)
                .foregroundColor(item.iconColor)
            Text(item.text)
                .bold()
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct WarningViewItem {
    let iconSystemName: String
    let iconColor: Color
    let text: String
}
