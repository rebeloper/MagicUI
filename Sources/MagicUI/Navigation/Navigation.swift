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
    
    /// Triggers a ``Navigation Step``
    /// - Parameter step: a ``Bool Binding`` representing a ``Navigation Step``
    @MainActor
    public static func trigger(_ step: Binding<Bool>) {
        total += 1
        if step.wrappedValue != true {
            step.wrappedValue = true
        }
    }
    
    /// Triggers an array of ``Navigation Step``s
    /// - Parameter steps: ``Bool Binding``s representing ``Navigation Step``s
    @MainActor
    public static func trigger(steps: [Binding<Bool>]) {
        for i in 0..<steps.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + (0.6 * Double(i)), execute: {
                trigger(steps[i])
            })
        }
    }
    
    /// Pops a ``Navigation Step``
    /// - Parameter dismiss: ``DismissAction`` provided by the current ``View``
    @MainActor
    public static func pop(with dismiss: DismissAction) {
        guard total > 0 else { return }
        popsToRoot = false
        dismiss()
        total -= 1
    }
    
    /// Pops all the ``Navigation Step``s
    /// - Parameter dismiss: ``DismissAction`` provided by the current ``View``
    @MainActor
    public static func popToRoot(with dismiss: DismissAction) {
        guard total > 0 else { return }
        popsToRoot = true
        dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + (0.6 * Double(total)), execute: {
            popsToRoot = false
        })
        total = 0
    }
    
    /// Pops the provided last ``Navigation Step``s
    /// - Parameters:
    ///   - last: count for the ``Navigation Step``s to pop
    ///   - dismiss: ``DismissAction`` provided by the current ``View``
    @MainActor
    public static func pop(last: Int, with dismiss: DismissAction) {
        guard total > 0 else { return }
        popsToRoot = false
        popsToLast = true
        self.last = last - 1
        dismiss()
        total -= last
    }
    
    /// Pops to the provided indexed ``Navigation Step``
    /// - Parameters:
    ///   - to: the index of the ``Navigation Step`` we pop to
    ///   - dismiss: ``DismissAction`` provided by the current ``View``
    @MainActor
    public static func pop(to: Int, with dismiss: DismissAction) {
        let last = total - to - 1
        popsToRoot = false
        popsToLast = true
        self.last = last
        dismiss()
        total -= last + 1
    }
    
}

