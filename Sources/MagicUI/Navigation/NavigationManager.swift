//
//  NavigationManager.swift
//  MagicUI
//
//  Created by Alex Nagy on 01.08.2022.
//

import SwiftUI

public class NavigationManager: ObservableObject {
    @Published var tagToPopTo = Int.max
    @Published var isPoping = false
}
