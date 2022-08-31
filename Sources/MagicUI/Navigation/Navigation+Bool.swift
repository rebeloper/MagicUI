//
//  Navigation+Bool.swift
//  
//
//  Created by Alex Nagy on 31.08.2022.
//

import SwiftUI

public extension Bool {
    func trigger(push: Binding<NavigationPush>) {
        if self {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                push.isActive.wrappedValue.toggle()
            })
        }
    }
}
