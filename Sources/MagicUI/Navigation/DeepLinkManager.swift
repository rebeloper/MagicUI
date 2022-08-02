//
//  DeepLinkManager.swift
//  MagicUI
//
//  Created by Alex Nagy on 02.08.2022.
//

import SwiftUI

public struct DeepLinkManager {
    public static func step(_ count: Int, isActive: Binding<Bool>, isLast: Bool = false, action: @escaping () -> ()) {
        if isActive.wrappedValue {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6 * Double(count), execute: {
                action()
                if isLast {
                    isActive.wrappedValue = false
                }
            })
        }
    }
}
