//
//  DeepLink.swift
//  
//
//  Created by Alex Nagy on 25.08.2022.
//

import SwiftUI

public struct DeepLink {
    /// Triggers a deep link
    /// - Parameters:
    ///   - deepLink: A binding to a Boolean value that determines the active state of the deep link
    ///   - steps: how many navigation steps does this deep link have
    ///   - setup: any setup before we trigger the deep link goes here
    public static func trigger(_ deepLink: Binding<Bool>, steps: Int, setup: @escaping () -> () = {}) {
        setup()
        deepLink.wrappedValue = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6 * Double(steps), execute: {
            deepLink.wrappedValue = false
        })
    }
    
    /// Handles the deep link active state change from inside an ``onReceive(:)``
    /// - Parameters:
    ///   - newValue: the new value received from an ``onReceive(:)``
    ///   - isPresented: A binding to a Boolean value that determines
    ///   the current / popped view's presented state
    public static func onReceive(_ newValue: Bool, isPresented: Binding<Bool>) {
        if newValue {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                isPresented.wrappedValue.toggle()
            })
        }
    }
}

