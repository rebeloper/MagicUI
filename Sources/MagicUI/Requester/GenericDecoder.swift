//
//  GenericDecoder.swift
//  Requester
//
//  Created by Alex Nagy on 27.07.2022.
//

import Foundation

/// Abstract class that any object that takes `Data` and decodes it into an expected type specified by `type`
/// should implement.
public protocol GenericDecoder {
    func decode<T>(expect type: T.Type, from data: Data) throws -> T where T : Decodable
}
