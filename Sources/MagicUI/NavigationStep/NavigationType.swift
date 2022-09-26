//
//  NavigationType.swift
//  NavigationStep
//
//  Created by Alex Nagy on 08.08.2022.
//

import Foundation

/// Navigation types
public enum NavigationType {
    case stack, sheet, sheetWith(onDismiss: (() -> Void)), fullScreenCover, fullScreenCoverWith(onDismiss: (() -> Void))
}
