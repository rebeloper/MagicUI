//
//  Navigation+Binding.swift
//  
//
//  Created by Alex Nagy on 31.08.2022.
//

import SwiftUI

public enum ToggleDeadline {
    case zero
    case regular
    case custom(value: Double)
}

public extension Binding<Bool> {
    
    private func toggle(deadline: ToggleDeadline = .regular) {
        switch deadline {
        case .zero:
            self.wrappedValue.toggle()
        case .regular:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.wrappedValue.toggle()
            })
        case .custom(let value):
            DispatchQueue.main.asyncAfter(deadline: .now() + value, execute: {
                self.wrappedValue.toggle()
            })
        }
    }
    
    func push(_ type: NavigationType, deadline: ToggleDeadline = .regular, action: (() -> (Void))? = nil) {
        switch type {
        case .stack:
            if let action {
                action()
                toggle(deadline: deadline)
            } else {
                toggle(deadline: .zero)
            }
        case .sheet:
            action?()
            toggle(deadline: .zero)
        case .fullScreenCover:
            action?()
            toggle(deadline: .zero)
        }
    }
}

