//
//  URLImage.swift
//  
//
//  Created by Alex Nagy on 30.08.2022.
//

import SwiftUI
import NukeUI

public struct URLImage<P: View>: View {
    
    private let url: String
    @ViewBuilder private var placeholder: () -> P
    private let width: CGFloat?
    private let height: CGFloat?
    
    public init(url: String,
                @ViewBuilder placeholder: @escaping () -> P,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        self.url = url
        self.placeholder = placeholder
        self.width = width
        self.height = height
    }
    
    public var body: some View {
        VStack {
            if let url = URL(string: url) {
                LazyImage(source: url) { state in
                    if let image = state.image {
                        image
                    } else if state.error != nil {
                        Image(systemName: "exclamationmark.triangle.fill")
                    } else {
                        ProgressView()
                            .asPushOutView()
                    }
                }
            } else {
                placeholder()
            }
        }
        .frame(width: width, height: height)
        .clippedContent()
    }
}

