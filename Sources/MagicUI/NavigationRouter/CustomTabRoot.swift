//
//  TabRoot.swift
//
//  Created by Alex Nagy on 09.01.2023.
//

import Foundation

public struct CustomTabRoot<Destination: RouterDestination, Tab: RouterTab, UnselectedTab: RouterUnselectedTab> {
    let root: Destination
    let tab: Tab
    let unselectedTab: UnselectedTab?
    
    public init(_ root: Destination, tab: Tab, unselectedTab: UnselectedTab? = nil) {
        self.root = root
        self.tab = tab
        self.unselectedTab = unselectedTab
    }
}
