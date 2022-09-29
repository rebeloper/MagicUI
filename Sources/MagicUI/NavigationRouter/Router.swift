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
    
    /// Pushes a destination onto the navigation stack.
    /// - Parameters:
    ///   - destination: The type of data that this destination matches.
    ///   - completion: Optional completion trigerred after the push.
    public func push<Destination: Hashable>(_ destination: Destination, completion: @escaping () -> () = {}) {
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
    
    /// Pops the last destination from the navigation stack
    public func pop() {
        DispatchQueue.main.async {
            self.paths[self.pathIndex].removeLast()
        }
    }
    
    /// Pops the last destination from the navigation stack
    public func pop() async {
        await withCheckedContinuation({ continuation in
            pop()
            continuation.resume()
        })
    }
    
    
    /// Pops the last destinations from the navigation stack.
    /// - Parameters:
    ///   - last: The amount of destinations to be popped.
    ///   - completion: Optional completion trigerred after the pop has finished.
    public func pop(last: Int, completion: @escaping () -> () = {}) {
        for i in 0..<min(paths[self.pathIndex].count, last) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6 * Double(i), execute: {
                self.pop()
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6 * Double(last), execute: {
            completion()
        })
    }
    
    /// Pops the last destinations from the navigation stack.
    /// - Parameter last: The amount of destinations to be popped.
    public func pop(last: Int) async {
        await withCheckedContinuation({ continuation in
            pop(last: last) {
                continuation.resume()
            }
        })
    }
    
    /// Pops all the destinations from the navigation stack.
    /// - Parameter completion: Optional completion trigerred after the pop has finished.
    public func popToStackRoot(completion: @escaping () -> () = {}) {
        pop(last: paths[self.pathIndex].count, completion: completion)
    }
    
    /// Pops all the destinations from the navigation stack.
    public func popToStackRoot() async {
        await withCheckedContinuation({ continuation in
            popToStackRoot {
                continuation.resume()
            }
        })
    }
    
    /// Toggles the wrapped value if a Bool binding.
    /// - Parameters:
    ///   - isPresented: A Bool binding.
    ///   - completion: Optional completion trigerred after the pop has finished.
    public func toggle(_ isPresented: Binding<Bool>, completion: @escaping () -> () = {}) {
        DispatchQueue.main.async {
            isPresented.wrappedValue.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    /// Toggles the wrapped value if a Bool binding.
    /// - Parameter isPresented: A Bool binding.
    public func toggle(_ isPresented: Binding<Bool>) async {
        await withCheckedContinuation({ continuation in
            toggle(isPresented) {
                continuation.resume()
            }
        })
    }
    
    /// Presents a destination associated to the `isPresented` value.
    /// - Parameters:
    ///   - isPresented: A Bool binding representing the presentation of the destination.
    ///   - completion: Optional completion trigerred after the pop has finished.
    public func push(_ isPresented: Binding<Bool>, completion: @escaping () -> () = {}) {
        DispatchQueue.main.async {
            isPresented.wrappedValue = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    /// Presents a destination associated to the `isPresented` value.
    /// - Parameter isPresented: A Bool binding representing the presentation of the destination.
    public func push(_ isPresented: Binding<Bool>) async {
        await withCheckedContinuation({ continuation in
            push(isPresented) {
                continuation.resume()
            }
        })
    }
    
    /// Pops a destination associated to the `isPresented` value.
    /// - Parameters:
    ///   - isPresented: A Bool binding representing the presentation of the destination.
    ///   - completion: Optional completion trigerred after the pop has finished.
    public func pop(_ isPresented: Binding<Bool>, completion: @escaping () -> () = {}) {
        DispatchQueue.main.async {
            isPresented.wrappedValue = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    /// Pops a destination associated to the `isPresented` value.
    /// - Parameter isPresented: A Bool binding representing the presentation of the destination.
    public func pop(_ isPresented: Binding<Bool>) async {
        await withCheckedContinuation({ continuation in
            pop(isPresented) {
                continuation.resume()
            }
        })
    }
}
