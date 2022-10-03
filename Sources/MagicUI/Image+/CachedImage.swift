//
//  CachedImage.swift
//  
//
//  Created by Alex Nagy on 01.10.2022.
//

import SwiftUI

struct CachedImage: View {
    
    let url: String
    
    var body: some View {
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

