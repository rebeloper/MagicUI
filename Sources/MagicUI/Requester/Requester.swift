//
//  Requester.swift
//  Requester
//
//  Created by Alex Nagy on 27.07.2022.
//

import Foundation

open class Requester: HTTPRequester {
    private let session: URLSession
    private var decoder: GenericDecoder?
    
    public init(
        session: URLSession = URLSession.shared,
        decoder: GenericDecoder? = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }
    
    /// Sends an `HTTPRequest` that expects the data returned as a `Decodable` set in the `type`
    /// - Parameters:
    ///   - request: an `HTTPRequest`
    ///   - type: a `Decodable` for the result that is expected in
    /// - Returns: a `RequestFetch` containing a `Decodable` set in the `type` and a `HTTPURLResponse`
    open func send<T: HTTPRequest, R: Decodable>(_ request: T, expect type: R.Type) async throws -> RequestFetch<R> {
        let (data, response) = try await data(for: request)
        guard let decoder = decoder else {
            throw RequestError.decoderFailure
        }
        let result = try decoder.decode(expect: R.self, from: data)
        let requestFetch = RequestFetch(result: result, response: response)
        return requestFetch
    }
    
    /// Sends an `HTTPRequest` that expects the data returned as a `JSON String`
    /// - Parameters:
    ///   - request: an `HTTPRequest`
    ///   - pretty: is the returned `JSON String` in `pretty` format; default is `false`
    /// - Returns: a `RequestJson` containing a `JSON String` and a `HTTPURLResponse`
    open func send<T: HTTPRequest>(_ request: T, pretty: Bool = false) async throws -> RequestJson {
        let (data, response) = try await data(for: request)
        let json = data.jsonString(pretty: pretty)
        let requestJson = RequestJson(json: json, response: response)
        return requestJson
    }
    
    /// Sends an `HTTPRequest` that expects the data returned as `Data`
    /// - Parameters:
    ///   - request: an `HTTPRequest`
    /// - Returns: a `RequestData` containing a `Data` and a `HTTPURLResponse`
    open func send<T: HTTPRequest>(_ request: T) async throws -> RequestData {
        let (data, response) = try await data(for: request)
        let requestData = RequestData(data: data, response: response)
        return requestData
    }
    
    private func data<T: HTTPRequest>(for request: T) async throws -> (Data, HTTPURLResponse) {
        guard let urlRequest = request.composeRequest() else {
            throw RequestError.requestCompositionFailure
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse else { throw RequestError.unexpectedResponse }
        
        guard (200...299).contains(response.statusCode) else {
            throw NSError(domain: "\(NetworkingError.init(errorCode: response.statusCode))", code: response.statusCode)
        }
        
        return (data, response)
    }
    
}

