//
//  HTTPRequester.swift
//  Requester
//
//  Created by Alex Nagy on 27.07.2022.
//

import Foundation

protocol HTTPRequester {
    func send<T: HTTPRequest, R: Decodable>(_ request: T, expect type: R.Type) async throws -> RequestFetch<R>
    func send<T: HTTPRequest>(_ request: T, pretty: Bool) async throws -> RequestJson
    func send<T: HTTPRequest>(_ request: T) async throws -> RequestData
}
