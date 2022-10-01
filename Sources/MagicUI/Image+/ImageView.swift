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
    
    private let source: String
    private let scale: ImageViewScale
    private let width: CGFloat?
    private let height: CGFloat?
    
    public init(_ source: String,
                scale: ImageViewScale = .fill,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        self.source = source
        self.scale = scale
        self.width = width
        self.height = height
    }
    
    public var body: some View {
        VStack {
            if source.contains("https") {
                URLImage(source: source, width: width, height: height)
                    .aspectRatio(contentMode: scale == .fill ? .fill : .fit)
            } else {
                if source == "" {
                    URLImage(source: source, width: width, height: height)
                        .aspectRatio(contentMode: scale == .fill ? .fill : .fit)
                } else {
                    Image(source)
                        .resizable()
                        .aspectRatio(contentMode: scale == .fill ? .fill : .fit)
                        .frame(width: width, height: height)
                        .clippedContent()
                }
            }
        }
    }
}

