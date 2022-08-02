//
//  DeepLinkManager.swift
//  MagicUI
//
//  Created by Alex Nagy on 02.08.2022.
//

import SwiftUI

public struct DeepLinkManager {
    public static func step(_ count: Int, isActive: Bool, action: @escaping () -> (), completion: @escaping () -> () = {}) {
        if isActive {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6 * Double(count), execute: {
                action()
            })
        }
    }
}
