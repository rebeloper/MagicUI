//
//  NavigationRouter+Protocols.swift
//
//  Created by Alex Nagy on 19.01.2023.
//

import SwiftUI

/// Adhere to this protocol to create a Destination enum for NavigationRouter
public protocol RouterDestination: Hashable, View {
    var modalValue: Int { get }
    
    init?(modalValue: Int)
}

#if os(iOS) || os(watchOS)
/// Adhere to this protocol to create a Tab or Custom Tab enum for NavigationRouter
public protocol RouterTab: Hashable, View { }

/// Adhere to this protocol to create a Custom Unselected Tab enum for NavigationRouter
public protocol RouterUnselectedTab: Hashable, View { }
#endif
