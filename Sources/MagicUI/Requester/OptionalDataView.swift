//
//  OptionalDataView.swift
//  RequesterDemo
//
//  Created by Alex Nagy on 26.12.2022.
//

import SwiftUI

public struct OptionalDataView<T: Decodable, C: View>: View {
    
    public let data: T?
    @ViewBuilder public var content: (T) -> C
    
    public init(for data: T?,
                content: @escaping (T) -> C) {
        self.data = data
        self.content = content
    }
    
    public var body: some View {
        if let data {
            content(data)
        } else {
            ProgressView()
        }
    }
}
