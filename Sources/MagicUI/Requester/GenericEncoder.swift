//
//  GenericEncoder.swift
//  Requester
//
//  Created by Alex Nagy on 27.07.2022.
//

import Foundation

/// Abstract class that any object that takes `Data` and decodes it into an expected type specified by `type`
/// should implement.
public protocol GenericEncoder {
    func encode<T>(_ object: T) throws -> Data where T : Encodable
}
