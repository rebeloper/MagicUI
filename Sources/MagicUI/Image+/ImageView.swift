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

public struct ImageView: View {
    
    private let name: String
    private let scale: ImageViewScale
    private let width: CGFloat?
    private let height: CGFloat?
    
    public init(name: String,
                scale: ImageViewScale = .fill,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        self.name = name
        self.scale = scale
        self.width = width
        self.height = height
    }
    
    public var body: some View {
        VStack {
            if name.contains("https") {
                URLImage(url: name, width: width, height: height)
                    .aspectRatio(contentMode: scale == .fill ? .fill : .fit)
            } else {
                if name == "" {
                    URLImage(url: name, width: width, height: height)
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

