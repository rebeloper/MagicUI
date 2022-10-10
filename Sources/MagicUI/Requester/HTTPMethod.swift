//
//  HTTPMethod.swift
//  Requester
//
//  Created by Alex Nagy on 27.07.2022.
//

public enum HTTPMethod: CustomStringConvertible {
    case get
    case head
    case post
    case put
    case delete
    case patch
    case connect
    case options
    case trace
    
    public var description: String {
        switch self {
        case .get: return "GET"
        case .head: return "HEAD"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        case .patch: return "PATCH"
        case .connect: return "CONNECT"
        case .options: return "OPTIONS"
        case .trace: return "TRACE"
        }
    }
}
