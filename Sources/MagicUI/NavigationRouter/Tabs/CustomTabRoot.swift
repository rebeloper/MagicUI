//
//  CustomTabRoot.swift
//
//  Created by Alex Nagy on 19.01.2023.
//

import Foundation

#if os(iOS) || os(watchOS)
public struct CustomTabRoot<Destination: RouterDestination, Tab: RouterTab, UnselectedTab: RouterUnselectedTab> {
    let root: Destination
    let tab: Tab
    let unselectedTab: UnselectedTab
    
    public init(_ root: Destination, tab: Tab, unselectedTab: UnselectedTab) {
        self.root = root
        self.tab = tab
        self.unselectedTab = unselectedTab
    }
}
#endif
