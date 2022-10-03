//
//  CachedImage.swift
//  
//
//  Created by Alex Nagy on 01.10.2022.
//

import SwiftUI

public struct CachedImage: View {
    
    private let url: String
    
    public init(_ url: String) {
        self.url = url
    }
    
    public var body: some View {
        CachedAsyncImage(url: URL(string: url)) { phase in
            if let image = phase.image {
                image
                    .resizable()
            } else if phase.error != nil {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.gray)
            } else {
                ProgressView()
            }
        }
    }
}

