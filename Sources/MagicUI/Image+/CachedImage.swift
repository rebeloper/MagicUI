//
//  CachedImage.swift
//  
//
//  Created by Alex Nagy on 01.10.2022.
//

import SwiftUI

public struct CachedImage: View {
    
    private let url: String
    private let showsError: Bool
    
    public init(_ url: String, showsError: Bool = false) {
        self.url = url
        self.showsError = showsError
    }
    
    public var body: some View {
        CachedAsyncImage(url: URL(string: url)) { phase in
            if let image = phase.image {
                image
                    .resizable()
            } else if phase.error != nil {
                if showsError {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.gray)
                } else {
                    ProgressView()
                }
            } else {
                ProgressView()
            }
        }
    }
}

