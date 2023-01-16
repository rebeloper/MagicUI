//
//  CustomTabRouterStack.swift
//
//  Created by Alex Nagy on 16.01.2023.
//

import SwiftUI

public struct CustomTabRouterStack<Destination: RouterDestination, Tab: RouterTab, UnselectedTab: RouterUnselectedTab>: View {
    
    @StateObject private var routes: Routes<Destination>
    
    private var roots: [Destination]
    private var selectedTabs: [Tab]
    private var unselectedTabs: [UnselectedTab]
    
    #if os(iOS) || os(watchOS)
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
    #endif
    
    #if os(iOS) || os(watchOS)
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

