//
//  RootNavigationStack.swift
//  MagicUI
//
//  Created by Alex Nagy on 01.08.2022.
//

import SwiftUI

public struct RootNavigationStack<C: View>: View {
    
    @StateObject private var navigationManager = NavigationManager()
    
    public let content: () -> C
    
    public init(content: @escaping () -> C) {
        self.content = content
    }
    
    public var body: some View {
        NavigationStack {
            content()
        }
        .environmentObject(navigationManager)
    }
}
