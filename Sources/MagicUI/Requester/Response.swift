//
//  Response.swift
//  Requester
//
//  Created by Alex Nagy on 27.07.2022.
//

import Foundation

public protocol Response {
    associatedtype T
    
    var httpResponse: HTTPURLResponse { get }
    var result: T { get }
}
