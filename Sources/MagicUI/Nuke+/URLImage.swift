//
//  URLImage.swift
//  
//
//  Created by Alex Nagy on 30.08.2022.
//

import SwiftUI

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
            AsyncImage(url: URL(string: url)) { phase in
                if let image = phase.image {
                    image
                } else if phase.error != nil {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.gray)
                } else {
                    placeholder()
                }
            }
        }
        .frame(width: width, height: height)
        .clippedContent()
    }
}

