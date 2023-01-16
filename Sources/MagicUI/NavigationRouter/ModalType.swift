//
//  ModalType.swift
//
//  Created by Alex Nagy on 04.01.2023.
//

import Foundation

public enum ModalType {
    case sheet
    #if !os(macOS)
    case fullScreenCover
    #endif
}
