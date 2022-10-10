//
//  JSONDecoder+GenericDecoder.swift
//  Requester
//
//  Created by Alex Nagy on 27.07.2022.
//

import Foundation

extension JSONDecoder: GenericDecoder {
    public func decode<T>(expect type: T.Type, from data: Data) throws -> T where T : Decodable {
        return try decode(type, from: data)
    }
}
