//
//  CustomTabRouterStack.swift
//
//  Created by Alex Nagy on 19.01.2023.
//

import SwiftUI

#if os(iOS) || os(watchOS)
public struct CustomTabRouterStack<Destination: RouterDestination, Tab: RouterTab, UnselectedTab: RouterUnselectedTab>: View {
    
    @StateObject private var router: Router<Destination>
    
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
        let router = Router<Destination>()
        router.tabSelection = tabSelection
        for i in 0..<roots.count {
            router.activeModalsIndices.append([roots[i].modalValue])
        }
        self._router = StateObject(wrappedValue: router)
    }
    
    /// Creates a custom TabView with navigation stacks with homogeneous navigation state that you
    /// can control.
    ///
    /// - Parameters:
    ///   - router: The navigation router.
    ///   - roots: The views to display when the stack is empty.
    ///   - tabs: Tab item view.
    ///   - unselectedTabs: Unselected tab item views.
    ///   - tabSelection: Binding for the selected tab.
    public init(router: Binding<Router<Destination>> ,roots: [Destination], tabs: [Tab], unselectedTabs: [UnselectedTab] = [], tabSelection: Int = 0) {
        self.roots = roots
        self.selectedTabs = tabs
        self.unselectedTabs = unselectedTabs
        router.tabSelection = tabSelection
        for i in 0..<roots.count {
            router.activeModalsIndices.append([roots[i].modalValue])
        }
        self._router = router
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
        let router = Router<Destination>()
        router.tabSelection = tabSelection
        for i in 0..<self.roots.count {
            router.activeModalsIndices.append([self.roots[i].modalValue])
        }
        self._router = StateObject(wrappedValue: router)
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
                            RootNavigationStack<Destination, Destination>(pathIndex: roots[index].modalValue, tabIndex: index) {
                                roots[index]
                            }
                            .opacity(index == router.tabSelection ? 1 : 0)
                        }
                    }
                    HStack {
                        Spacer()
                        ForEach(selectedTabs.indices, id: \.self) { index in
                            Group {
                                if router.tabSelection == index {
                                    selectedTabs[index]
                                } else {
                                    unselectedTabs[index]
                                }
                            }
                            .onTapGesture {
                                router.tabSelection = index
                            }
                            if index != selectedTabs.count {
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .environmentObject(router)
        .onReceive(router.$activeModalsIndices) { newValue in
            guard newValue.count - 1 >= router.tabSelection, newValue[router.tabSelection].count >= 1 else { return }
            router.pathIndex[router.tabSelection] = newValue[router.tabSelection].count - 1
        }
    }
}
#endif
