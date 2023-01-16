//
//  TabRouterStack.swift
//
//  Created by Alex Nagy on 16.01.2023.
//

import SwiftUI

public struct TabRouterStack<Destination: RouterDestination, Tab: RouterTab>: View {
    
    @StateObject private var routes: Routes<Destination>
    
    private var roots: [Destination]
    private var selectedTabs: [Tab]
    
    #if os(iOS) || os(watchOS)
    public init(roots: [Destination], tabs: [Tab], tabSelection: Int = 0) {
        self.roots = roots
        self.selectedTabs = tabs
        let routes = Routes<Destination>()
        routes.tabSelection = tabSelection
        for i in 0..<roots.count {
            routes.activeModalsIndices.append([roots[i].rawValue])
        }
        self._routes = StateObject(wrappedValue: routes)
    }
    #endif
    
    #if os(iOS) || os(watchOS)
    public init(_ roots: [TabRoot<Destination, Tab>], tabSelection: Int = 0) {
        self.roots = roots.compactMap( {$0.root} )
        self.selectedTabs = roots.compactMap( {$0.tab} )
        let routes = Routes<Destination>()
        routes.tabSelection = tabSelection
        for i in 0..<self.roots.count {
            routes.activeModalsIndices.append([self.roots[i].rawValue])
        }
        self._routes = StateObject(wrappedValue: routes)
    }
    #endif
    
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
                TabView(selection: $routes.tabSelection) {
                    ForEach(roots.indices, id: \.self) { index in
                        RootNavigationStack<Destination, Destination>(pathIndex: roots[index].rawValue, tabIndex: index) {
                            roots[index]
                        }
                        .tabItem {
                            selectedTabs[index]
                        }
                        .id(index)
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

