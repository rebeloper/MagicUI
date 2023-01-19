//
//  TabRoot.swift
//
//  Created by Alex Nagy on 19.01.2023.
//

import SwiftUI

#if os(iOS) || os(watchOS)
public struct TabRoot<Destination: RouterDestination, Tab: RouterTab> {
    let root: Destination
    let tab: Tab
    
    public init(_ root: Destination, tab: Tab) {
        self.root = root
        self.tab = tab
    }
}
#endif
