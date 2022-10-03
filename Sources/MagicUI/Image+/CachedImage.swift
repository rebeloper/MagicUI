//
//  CachedImage.swift
//  
//
//  Created by Alex Nagy on 01.10.2022.
//

import SwiftUI

public struct CachedImage: View {
    
    public let url: String
    
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

