//
//  Navigation+Binding.swift
//  
//
//  Created by Alex Nagy on 31.08.2022.
//

import SwiftUI

public extension Binding<NavigationPush> {
    
    private func toggle(deadline: NavigationToggleDeadline = .regular) {
        switch deadline {
        case .zero:
            self.isActive.wrappedValue.toggle()
        case .regular:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.isActive.wrappedValue.toggle()
            })
        case .custom(let value):
            DispatchQueue.main.asyncAfter(deadline: .now() + value, execute: {
                self.isActive.wrappedValue.toggle()
            })
        }
    }
    
    func trigger(_ action: @escaping (() -> (Void))) {
        trigger(action: action)
    }
    
    func trigger(deadline: NavigationToggleDeadline = .regular, action: (() -> (Void))? = nil) {
        switch self.type.wrappedValue {
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

public extension Binding<NavigationPop> {
    func trigger(_ dismiss: DismissAction) {
        self.isActive.wrappedValue.toggle()
        dismiss()
    }
}

public extension Binding<Bool> {
    func trigger(steps: Int, action: @escaping () -> () = {}) {
        action()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.wrappedValue = true
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 + 0.6 * Double(steps), execute: {
            self.wrappedValue = false
        })
    }
}
