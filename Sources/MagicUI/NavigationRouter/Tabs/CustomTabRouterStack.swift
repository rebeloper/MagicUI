//
//  CustomTabRouterStack.swift
//
//  Created by Alex Nagy on 19.01.2023.
//

import SwiftUI

#if os(iOS) || os(watchOS)
public struct CustomTabRouterStack<Destination: RouterDestination, Tab: RouterTab, UnselectedTab: RouterUnselectedTab>: View {
    
    @StateObject private var routes: Routes<Destination>
    
    private var roots: [Destination]
    private var selectedTabs: [Tab]
    private var unselectedTabs: [UnselectedTab]
    
    /// Creates a custom TabView with navigation stacks with homogeneous navigation state that you
    /// can control.
    /// 
    /// - Parameters:
    ///   - roots: The views to display when the stack is empty.
    ///   - tabs: Tab item view.
    ///   - unselectedTabs: Unselected tab item views.
    ///   - tabSelection: Binding for the selected tab.
    public init(roots: [Destination], tabs: [Tab], unselectedTabs: [UnselectedTab] = [], tabSelection: Int = 0) {
        self.roots = roots
        self.selectedTabs = tabs
        self.unselectedTabs = unselectedTabs
        let routes = Routes<Destination>()
        routes.tabSelection = tabSelection
        for i in 0..<roots.count {
            routes.activeModalsIndices.append([roots[i].rawValue])
        }
        self._routes = StateObject(wrappedValue: routes)
    }
    
    /// Creates a custom TabView with navigation stacks with homogeneous navigation state that you
    /// can control.
    ///
    /// - Parameters:
    ///   - roots: The tab items and views to display when the stack is empty.
    ///   - tabSelection: Binding for the selected tab.
    public init(_ roots: [CustomTabRoot<Destination, Tab, UnselectedTab>], tabSelection: Int = 0) {
        self.roots = roots.compactMap( {$0.root} )
        self.selectedTabs = roots.compactMap( {$0.tab} )
        self.unselectedTabs = roots.compactMap( {$0.unselectedTab} )
        let routes = Routes<Destination>()
        routes.tabSelection = tabSelection
        for i in 0..<self.roots.count {
            routes.activeModalsIndices.append([self.roots[i].rawValue])
        }
        self._routes = StateObject(wrappedValue: routes)
    }
    
    public var body: some View {
        Group {
            if roots.count == 1 {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("Please provide more than one tab in\n**TabRouterStack** or use **RouterStack** instead")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .font(.caption)
                }
            } else {
                VStack(spacing: 0) {
                    ZStack {
                        ForEach(roots.indices, id: \.self) { index in
                            RootNavigationStack<Destination, Destination>(pathIndex: roots[index].rawValue, tabIndex: index) {
                                roots[index]
                            }
                            .opacity(index == routes.tabSelection ? 1 : 0)
                        }
                    }
                    HStack {
                        Spacer()
                        ForEach(selectedTabs.indices, id: \.self) { index in
                            Group {
                                if routes.tabSelection == index {
                                    selectedTabs[index]
                                } else {
                                    unselectedTabs[index]
                                }
                            }
                            .onTapGesture {
                                routes.tabSelection = index
                            }
                            if index != selectedTabs.count {
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .environmentObject(routes)
        .onReceive(routes.$activeModalsIndices) { newValue in
            guard newValue.count - 1 >= routes.tabSelection, newValue[routes.tabSelection].count >= 1 else { return }
            routes.pathIndex[routes.tabSelection] = newValue[routes.tabSelection].count - 1
        }
    }
}
#endif
