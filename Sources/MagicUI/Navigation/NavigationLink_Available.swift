//
//  NavigationLink_Available.swift
//  MagicUI
//
//  Created by Alex Nagy on 15.09.2021.
//

import SwiftUI

public struct NavigationLink_Available: View {
    
    @ObservedObject public var navigation: Navigation
    
    public var body: some View {
        if #available(iOS 15, *, macOS 12.0, *, tvOS 15.0, *, watchOS 8.0, *) {
            if #available(iOS 16, *, macOS 13.0, *, tvOS 16.0, *, watchOS 9.0, *) {
                // SwiftUI 4
                NavigationLinkSwiftUI4(isActive: $navigation.isPushed, destination: {
                    navigation.destination
                        .onDisappear {
                            navigation.onDismiss?()
                        }
                }, label: {
                    EmptyView()
                })
            } else {
                // SwiftUI 3
                NavigationLink(isActive: $navigation.isPushed, destination: {
                    navigation.destination
                        .onDisappear {
                            navigation.onDismiss?()
                        }
                }, label: {
                    EmptyView()
                })
            }
            
        } else {
            // SwiftUI 2 and 1
            NavigationLink(
                destination:
                    navigation.destination
                    .onDisappear {
                        navigation.onDismiss?()
                    },
                isActive:
                    $navigation.isPushed,
                label: {
                    EmptyView()
                })
        }
    }
}
