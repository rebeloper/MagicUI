//
//  Binding+.swift
//  
//
//  Created by Alex Nagy on 03.12.2022.
//

import SwiftUI

public extension Binding {
    func allowing(predicate: @escaping (Value) -> Bool) -> Self {
        Binding(get: { self.wrappedValue },
                set: { newValue in
                    let oldValue = self.wrappedValue
                    // Need to force a change to trigger the binding to refresh
                    self.wrappedValue = newValue
                    if !predicate(newValue) && predicate(oldValue) {
                        // And set it back if it wasn't legal and the previous was
                        self.wrappedValue = oldValue
                    }
                })
    }
}
