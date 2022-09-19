//
//  AsyncButton.swift
//  
//
//  Created by Alex Nagy on 19.09.2022.
//

import SwiftUI

public struct AsyncButton<Label: View>: View {
    
    public let action: () -> Void
    public let label: () -> Label
    
    public var body: some View {
        Button(action: {
            DispatchQueue.main.async {
                action()
            }
        }, label: label)
    }
}
