//
//  SlideInViewManager.swift
//  
//
//  Created by Alex Nagy on 24.01.2023.
//

import SwiftUI

@propertyWrapper
public struct SlideInViewManager: DynamicProperty {
    
    @EnvironmentObject public var context: SlideInViewManagerContext
    
    public var wrappedValue: Bool {
        get {
            context.isActive
        }
        nonmutating set {
            context.isActive = newValue
        }
    }
    
    public init() { }
}

@MainActor
final public class SlideInViewManagerContext: ObservableObject {
    
    @Published public var isActive: Bool = false
    
    public init() { }
    
}
