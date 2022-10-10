//
//  Request.swift
//  Requester
//
//  Created by Alex Nagy on 27.07.2022.
//

import Foundation

/// This is a basic implementation of the `HTTPRequest` protocol.
/// If you have common properties that are the same across multiple requests
/// then subclassing `Request` and filling in those common values is one option
/// so `Request` is a class not a struct for that reason but using `struct`s is also encouraged
/// with `HTTPRequest`
open class Request: HTTPRequest {
    
    public var scheme: Scheme
    
    public var host: String
    
    public var path: String
    
    public var port: Int?
    
    public var headers: [String : String]?
    
    public var queryParameters: [String : String]?
    
    public var method: HTTPMethod
    
    public var body: HTTPBody?
    
    public init(
        scheme: Scheme,
        host: String,
        path: String,
        port: Int? = nil,
        method: HTTPMethod,
        headers: [String: String]? = nil,
        queryParameters: [String: String]? = nil,
        body: HTTPBody? = nil) {
            self.scheme = scheme
            self.host = host
            self.path = path
            self.port = port
            self.method = method
            self.body = body
            self.headers = headers
            self.queryParameters = queryParameters
        }
}
