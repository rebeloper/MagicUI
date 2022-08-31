//
//  NavigationPush.swift
//  
//
//  Created by Alex Nagy on 31.08.2022.
//

import Foundation

public struct NavigationPush {
    public var isActive: Bool
    public var type: NavigationType
    
    public init(_ type: NavigationType) {
        self.isActive = false
        self.type = type
    }
}
