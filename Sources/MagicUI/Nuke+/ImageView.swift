//
//  ImageView.swift
//  
//
//  Created by Alex Nagy on 30.08.2022.
//

import SwiftUI

public enum ImageViewScale {
    case fill, fit
}

public struct ImageView<P: View>: View {
    
    private let name: String
    @ViewBuilder private var placeholder: () -> P
    private let scale: ImageViewScale
    private let width: CGFloat?
    private let height: CGFloat?
    
    public init(name: String,
                @ViewBuilder placeholder: @escaping () -> P,
                scale: ImageViewScale = .fill,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        self.name = name
        self.placeholder = placeholder
        self.scale = scale
        self.width = width
        self.height = height
    }
    
    public var body: some View {
        VStack {
            if name.contains("https") {
                URLImage(url: name, placeholder: placeholder, width: width, height: height)
                    .aspectRatio(contentMode: scale == .fill ? .fill : .fit)
            } else {
                if name == "" {
                    URLImage(url: name, placeholder: placeholder, width: width, height: height)
                        .aspectRatio(contentMode: scale == .fill ? .fill : .fit)
                } else {
                    Image(name)
                        .resizable()
                        .aspectRatio(contentMode: scale == .fill ? .fill : .fit)
                        .frame(width: width, height: height)
                        .clippedContent()
                }
            }
        }
    }
}

