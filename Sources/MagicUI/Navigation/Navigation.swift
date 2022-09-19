//
//  Navigation.swift
//  
//
//  Created by Alex Nagy on 16.09.2022.
//

import SwiftUI

public struct Navigation {
    
    public static func pop(_ path: Binding<Bool>...) {
        if path.count >= 2 {
            for i in 0..<path.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 + 0.6 * Double(i), execute: {
                    path[i].wrappedValue.toggle()
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 + 0.6 * Double(path.count), execute: {
                    path[i].wrappedValue.toggle()
                })
            }
        } else {
            DispatchQueue.main.async {
                path[0].wrappedValue = false
            }
        }
    }
    
    public static func present(_ path: Binding<Bool>...) {
        if path.count >= 2 {
            for i in 0..<path.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 + 0.6 * Double(i), execute: {
                    path[i].wrappedValue.toggle()
                })
            }
        } else {
            DispatchQueue.main.async {
                path[0].wrappedValue = true
            }
        }
    }
    
}
