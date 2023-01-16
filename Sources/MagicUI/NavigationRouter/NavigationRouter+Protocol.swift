//
//  NavigationRouter+Protocol.swift.swift
//
//  Created by Alex Nagy on 16.01.2023.
//

import SwiftUI

public protocol RouterDestination: Hashable, View {
    var rawValue: Int { get }
    
    init?(rawValue: Int)
}

public protocol RouterTab: Hashable, View { }
public protocol RouterUnselectedTab: Hashable, View { }
