//
//  HTTPRequest.swift
//  Requester
//
//  Created by Alex Nagy on 27.07.2022.
//

import Foundation

public protocol HTTPRequest {
    
    var scheme: Scheme { get }
    var host: String { get }
    var path: String { get }
    var port: Int? { get }
    var queryParameters: [String: String]? { get }
    var headers: [String: String]? { get }
    var method: HTTPMethod { get }
    var body: HTTPBody? { get }
    
    func composeRequest() -> URLRequest?
}

public extension HTTPRequest {
    
    func convert(queryParameters: [String: String]) -> [URLQueryItem] {
        return queryParameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
    }
    
    func urlFromComponents() -> URL? {
        var components = URLComponents()
        components.scheme = scheme.description
        components.host = host
        components.path = path
        components.port = port
        
        if let query = queryParameters {
            components.queryItems = convert(queryParameters: query)
        }
        return components.url
    }

    func composeRequest() -> URLRequest? {
        guard let url = urlFromComponents() else { return nil }
    
        var request = URLRequest(url: url)
        request.httpMethod = method.description
        headers.map {
            for (headerField, value) in $0 {
                request.addValue(value, forHTTPHeaderField: headerField)
            }
        }
        request.httpBody = body?.data
        return request
    }
}
