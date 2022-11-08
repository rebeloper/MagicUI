//
//  Array+.swift
//  
//
//  Created by Alex Nagy on 09.11.2022.
//

import Foundation

public extension Array {
    func pluralize(_ base: String) -> String {
        "\(base)\(self.count > 1 ? "s" : "")"
    }
}
