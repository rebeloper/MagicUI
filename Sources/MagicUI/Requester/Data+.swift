//
//  Data+.swift
//  RequesterDemo
//
//  Created by Alex Nagy on 27.07.2022.
//

import Foundation

public extension Data {
    func jsonString(pretty: Bool = false) -> String {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) {
            if pretty, let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                return String(decoding: jsonData, as: UTF8.self)
            } else {
                return String(decoding: self, as: UTF8.self)
            }
        } else {
            return "JSON data is malformed"
        }
    }
}
