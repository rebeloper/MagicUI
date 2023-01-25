//
//  MultiItemPickerStyle.swift
//  
//
//  Created by Alex Nagy on 14.10.2022.
//

import Foundation

public enum MultiItemPickerStyle {
    case automatic
    #if !os(watchOS)
    case sidebar
    #endif
    #if os(iOS)
    case insetGrouped
    case grouped
    #endif
    #if !os(watchOS)
    case inset
    #endif
    case plain
}
