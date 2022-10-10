//
//  Scheme.swift
//  Requester
//
//  Created by Alex Nagy on 27.07.2022.
//

/// HTTP Scheme
public enum Scheme: CustomStringConvertible {
    case http
    case https
    
    public var description: String {
        switch self {
        case .http:
            return "http"
        case .https:
            return "https"
        }
    }
}
