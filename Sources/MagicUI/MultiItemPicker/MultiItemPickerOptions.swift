//
//  MultiItemPickerOptions.swift
//  
//
//  Created by Alex Nagy on 14.10.2022.
//

import SwiftUI

public struct MultiItemPickerOptions {
    public var showsAllToggle: Bool
    public var iconAlignment: MultiItemPickerIconAlignment
    public var style: MultiItemPickerStyle?
    public var rowSeparatorVisibility: Visibility?
    public var rowSeparatorTint: MultiItemPickerRowSeparatorTint?
    public var rowInsets: EdgeInsets?
    
    public init(showsAllToggle: Bool = true,
                iconAlignment: MultiItemPickerIconAlignment = .trailing,
                style: MultiItemPickerStyle? = nil,
                rowSeparator visibility: Visibility? = nil,
                rowSeparatorTint: MultiItemPickerRowSeparatorTint? = nil,
                rowInsets: EdgeInsets? = nil) {
        self.showsAllToggle = showsAllToggle
        self.iconAlignment = iconAlignment
        self.style = style
        self.rowSeparatorVisibility = visibility
        self.rowSeparatorTint = rowSeparatorTint
        self.rowInsets = rowInsets
    }
}
