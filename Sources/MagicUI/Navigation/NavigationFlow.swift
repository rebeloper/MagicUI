//
//  NavigationFlow.swift
//  
//
//  Created by Alex Nagy on 16.09.2022.
//

import SwiftUI

public struct NavigationFlow {
    
    public static func pop(path: [Binding<Bool>]) {
        for i in 0..<path.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 + 0.6 * Double(i), execute: {
                path[i].wrappedValue.toggle()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 + 0.6 * Double(path.count), execute: {
                path[i].wrappedValue.toggle()
            })
        }
    }
    
    public static func present(path: [Binding<Bool>]) {
        for i in 0..<path.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 + 0.6 * Double(i), execute: {
                path[i].wrappedValue.toggle()
            })
        }
    }
}
