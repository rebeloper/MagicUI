//
//  MultiItemPickerRowSeparatorTint.swift
//  
//
//  Created by Alex Nagy on 14.10.2022.
//

import SwiftUI

public struct MultiItemPickerRowSeparatorTint {
    public var color: Color?
    public var edges: VerticalEdge.Set
    
    public init(color: Color?, edges: VerticalEdge.Set = .all) {
        self.color = color
        self.edges = edges
    }
}
