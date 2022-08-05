//
//  LinkView.swift
//  
//
//  Created by Alex Nagy on 05.08.2022.
//

import SwiftUI

public struct LinkView<C: View>: View {
    
    @Environment(\.openURL) var openURL
    
    let destination: URL
    let isButton: Bool
    let content: () -> C
    
    public init(destination: URL,
         isButton: Bool = true,
         content: @escaping () -> C) {
        self.destination = destination
        self.isButton = isButton
        self.content = content
    }
    
    public init(_ destination: String,
         isButton: Bool = true,
         content: @escaping () -> C) {
        self.destination = URL(string: destination)!
        self.isButton = isButton
        self.content = content
    }
    
    public var body: some View {
        if isButton {
            Button {
                openURL(destination)
            } label: {
                content()
            }
        } else {
            content()
                .onTapGesture {
                    openURL(destination)
                }
        }
    }
}

public extension View {
    func link(_ destination: URL, isButton: Bool = true) -> some View {
        LinkView(destination: destination, isButton: isButton) {
            self
        }
    }
    
    func link(_ destination: String, isButton: Bool = true) -> some View {
        LinkView(destination, isButton: isButton) {
            self
        }
    }
}
