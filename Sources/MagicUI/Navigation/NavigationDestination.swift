//
//  NavigationDestination.swift
//  
//
//  Created by Alex Nagy on 19.09.2022.
//

import SwiftUI

public struct NavigationDestination {
    public var isActive: Bool
    public let type: NavigationType
    
    public init(type: NavigationType) {
        self.isActive = false
        self.type = type
    }
}
