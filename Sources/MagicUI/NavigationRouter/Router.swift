//
//  Router.swift
//  
//
//  Created by Alex Nagy on 28.09.2022.
//

import SwiftUI

/// Navigation coordinator
public class Router: ObservableObject {
    
    @Published internal var paths = Array(repeating: NavigationPath(), count: 100)
    @Published internal var pathIndex = 0
    
    public enum PopType {
        case one
        case the(last: Int)
        case to(index: Int)
        case toStackRoot
    }
    
    /// Pushes a destination onto the navigation stack.
    /// - Parameters:
    ///   - destination: The type of data that this destination matches.
    ///   - completion: Optional completion trigerred after the push.
    public func push<Destination: Hashable>(_ destination: Destination, completion: @escaping () -> () = {}) {
        guard pathIndex < paths.count else { return }
        DispatchQueue.main.async {
            self.paths[self.pathIndex].append(destination)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    /// Pushes a destination onto the navigation stack.
    /// - Parameter destination: The type of data that this destination matches.
    public func push<Destination: Hashable>(_ destination: Destination) async {
        await withCheckedContinuation({ continuation in
            push(destination) {
                continuation.resume()
            }
        })
    }
    
    /// Pops one or more destinations from the end of this path according to the provided `PopType`
    /// - Parameters:
    ///   - type: The pop type
    ///   - completion: Optional completion trigerred after the push.
    public func pop(_ type: PopType = .one, completion: @escaping () -> () = {}) {
        switch type {
        case .one:
            pop(theLast: 1, completion: completion)
        case .the(let last):
            pop(theLast: last, completion: completion)
        case .to(let index):
            pop(to: index, completion: completion)
        case .toStackRoot:
            popToStackRoot(completion: completion)
        }
    }
    
    /// Pops one or more destinations from the end of this path according to the provided `PopType`
    /// - Parameter type: The pop type
    public func pop(_ type: PopType = .one) async {
        await withCheckedContinuation({ continuation in
            pop(type) {
                continuation.resume()
            }
        })
    }
    
    /// Removes the last destination from the navigation stack
    private func removeLast() {
        guard pathIndex < paths.count, !paths[pathIndex].isEmpty else { return }
        DispatchQueue.main.async {
            self.paths[self.pathIndex].removeLast()
        }
    }
    
    /// Pops the last destinations from the navigation stack.
    /// - Parameters:
    ///   - last: The amount of destinations to be popped.
    ///   - completion: Optional completion trigerred after the pop has finished.
    private func pop(theLast last: Int, completion: @escaping () -> () = {}) {
        for i in 0..<min(paths[self.pathIndex].count, last) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6 * Double(i), execute: {
                self.removeLast()
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6 * Double(last), execute: {
            completion()
        })
    }
    
    /// Pops to the destination with the specified index.
    /// - Parameters:
    ///   - index: The index of the destination to be popped to.
    ///   - completion: Optional completion trigerred after the pop has finished.
    private func pop(to index: Int, completion: @escaping () -> () = {}) {
        let last = paths[self.pathIndex].count - index
        pop(theLast: last, completion: completion)
    }
    
    
    /// Pops all the destinations from the navigation stack.
    /// - Parameter completion: Optional completion trigerred after the pop has finished.
    private func popToStackRoot(completion: @escaping () -> () = {}) {
        pop(theLast: paths[self.pathIndex].count, completion: completion)
    }
    
    
    /// Toggles the wrapped value if a Bool binding.
    /// - Parameters:
    ///   - isActive: A Bool binding.
    ///   - completion: Optional completion trigerred after the pop has finished.
    public func toggle(_ isActive: Binding<Bool>, completion: @escaping () -> () = {}) {
        DispatchQueue.main.async {
            isActive.wrappedValue.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    /// Toggles the wrapped value if a Bool binding.
    /// - Parameter isActive: A Bool binding.
    public func toggle(_ isActive: Binding<Bool>) async {
        await withCheckedContinuation({ continuation in
            toggle(isActive) {
                continuation.resume()
            }
        })
    }
    
    /// Presents a destination associated to the `isActive` value.
    /// - Parameters:
    ///   - isActive: A Bool binding representing the presentation of the destination.
    ///   - completion: Optional completion trigerred after the pop has finished.
    public func push(_ isActive: Binding<Bool>, completion: @escaping () -> () = {}) {
        DispatchQueue.main.async {
            isActive.wrappedValue = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    /// Presents a destination associated to the `isActive` value.
    /// - Parameter isActive: A Bool binding representing the presentation of the destination.
    public func push(_ isActive: Binding<Bool>) async {
        await withCheckedContinuation({ continuation in
            push(isActive) {
                continuation.resume()
            }
        })
    }
    
    /// Pops a destination associated to the `isActive` value.
    /// - Parameters:
    ///   - isActive: A Bool binding representing the presentation of the destination.
    ///   - completion: Optional completion trigerred after the pop has finished.
    public func pop(_ isActive: Binding<Bool>, completion: @escaping () -> () = {}) {
        DispatchQueue.main.async {
            isActive.wrappedValue = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    /// Pops a destination associated to the `isActive` value.
    /// - Parameter isActive: A Bool binding representing the presentation of the destination.
    public func pop(_ isActive: Binding<Bool>) async {
        await withCheckedContinuation({ continuation in
            pop(isActive) {
                continuation.resume()
            }
        })
    }
}
