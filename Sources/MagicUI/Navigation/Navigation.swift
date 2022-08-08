//
//  Navigation.swift
//  StringNavigation
//
//  Created by Alex Nagy on 08.08.2022.
//

import SwiftUI

public struct Navigation {
    
    static var total = 0
    static var popsToRoot = false
    static var popsToLast = false
    static var last = 0
    
    public static func push(_ path: Binding<Bool>) {
        total += 1
        if path.wrappedValue != true {
            path.wrappedValue = true
        }
    }
    
    public static func pop(with dismiss: DismissAction) {
        guard total > 0 else { return }
        popsToRoot = false
        dismiss()
        total -= 1
    }
    
    public static func popToRoot(with dismiss: DismissAction) {
        guard total > 0 else { return }
        popsToRoot = true
        dismiss()
        total = 0
    }
    
    public static func pop(last: Int, with dismiss: DismissAction) {
        guard total > 0 else { return }
        popsToRoot = true
        popsToLast = true
        self.last = last - 1
        dismiss()
        total -= last
    }
    
    public static func pop(to: Int, with dismiss: DismissAction) {
        let last = total - to - 1
        popsToRoot = true
        popsToLast = true
        self.last = last
        dismiss()
        total -= last + 1
    }
    
    public static func pushDeepLink(_ path: Binding<Bool>, step: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + (0.6 * Double(step)), execute: {
            push(path)
        })
    }
}

