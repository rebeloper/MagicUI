//
//  NavigationType.swift
//  StringNavigation
//
//  Created by Alex Nagy on 08.08.2022.
//

import Foundation

/// Navigation types used by ``navigationDestination(_ type:isPresented:destination:onDismiss:)``
public enum NavigationType {
    case stack, sheet, fullScreenCover
}
