//
//  RequestError.swift
//  Requester
//
//  Created by Alex Nagy on 27.07.2022.
//

import Foundation

public enum RequestError: Error {
    /// Request composition has failed
    case requestCompositionFailure
    /// URLResponse is an unexpected type
    case unexpectedResponse
    /// Decoder is not initialized
    case decoderFailure
}
