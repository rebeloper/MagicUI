//
//  NavigationPath+.swift
//  
//
//  Created by Alex Nagy on 04.07.2022.
//

import SwiftUI

public extension NavigationPath {
    
    enum PopType {
        case one
        case the(last: Int)
        case to(index: Int)
        case toRoot
    }
    
    /// Pushes a new value to the end of this path.
    /// - Parameters:
    ///   - value: The value to push.
    mutating func push<V>(_ value: V, completion: @escaping () -> () = {}) where V : Hashable {
        append(value)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    /// Pops values from the end of this path according to the provided `PopType`
    /// - Parameter type: The pop type
    mutating func pop(_ type: PopType = .one, completion: @escaping () -> () = {}) {
        switch type {
        case .one:
            pop(theLast: 1, completion: completion)
        case .the(let last):
            pop(theLast: last, completion: completion)
        case .to(let index):
            pop(to: index, completion: completion)
        case .toRoot:
            popToRoot(completion: completion)
        }
    }
    
    /// Pops values from the end of this path.
    ///
    /// - Parameters:
    ///   - last: The number of values to remove
    mutating private func pop(theLast last: Int, completion: @escaping () -> () = {}) {
        guard !isEmpty else { return }
        removeLast(last: last, completion: completion)
    }
    
    /// Pops values from the end of this path to the specified index.
    ///
    /// - Parameters:
    ///   - index: The index of the path to pop to.
    mutating private func pop(to index: Int, completion: @escaping () -> () = {}) {
        guard !isEmpty else { return }
        guard index >= 0 else {
            print("NavigationPath: Tried to pop to an index (\(index)) smaller than 0. Popping to root instead.")
            popToRoot(completion: completion)
            return
        }
        guard index != 0 else {
            print("NavigationPath: Popping to index 0. Please use the preferred 'poptoRoot()' instead.")
            popToRoot(completion: completion)
            return
        }
        let last = count - index
        guard last > 0 else {
            print("NavigationPath: Tried to pop to an index (\(index)) greater then the path count (\(count))")
            return
        }
        removeLast(last: last, completion: completion)
    }
    
    /// Pops all the values from this path.
    mutating private func popToRoot(completion: @escaping () -> () = {}) {
        pop(theLast: count, completion: completion)
    }
    
    mutating private func removeLast(last: Int, completion: @escaping () -> () = {}) {
        removeLast(min(last, count))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
}

