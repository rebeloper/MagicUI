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
    /// the type of the ``NavigationStep``
    public let type: NavigationType
    
    /// Navigation transition description between two views
    /// - Parameter type: the type of the navigation transition
    public init(type: NavigationType) {
        self.isActive = false
        self.type = type
    }
}
