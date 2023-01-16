//
//  DismissType.swift
//
//  Created by Alex Nagy on 05.01.2023.
//

import Foundation

public enum DismissType {
    case dismiss(type: RoutesDismissType = .one)
    case dismissRoot
}
