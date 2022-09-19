//
//  AsyncButton.swift
//  
//
//  Created by Alex Nagy on 19.09.2022.
//

import SwiftUI

struct AsyncButton<Label: View>: View {
    
    let action: () -> Void
    let label: () -> Label
    
    var body: some View {
        Button(action: {
            DispatchQueue.main.async {
                action()
            }
        }, label: label)
    }
}
