//
//  AsyncButton.swift
//  
//
//  Created by Alex Nagy on 19.09.2022.
//

import SwiftUI

public struct AsyncButton<Label: View>: View {
    
    private let action: () -> Void
    private let label: () -> Label
    
    public init(action: @escaping () -> Void, label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }
    
    public var body: some View {
        Button(action: {
            DispatchQueue.main.async {
                action()
            }
        }, label: label)
    }
}
