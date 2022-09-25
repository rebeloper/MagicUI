//
//  NavigationStep.swift
//  
//
//  Created by Alex Nagy on 19.09.2022.
//

import SwiftUI

/// Navigation transition description between two views
public struct NavigationStep {
    
    /// is the ``NavigationStep`` active
    public var isActive: Bool
    
    /// Navigation transition description between two views
    public init() {
        self.isActive = false
    }
}
