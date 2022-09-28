//
//  Router.swift
//  
//
//  Created by Alex Nagy on 28.09.2022.
//

import SwiftUI

public class Router: ObservableObject {
    @Published internal var paths = Array(repeating: NavigationPath(), count: 100)
    @Published internal var pathIndex = 0
    
    public func push<Destination: Hashable>(_ destination: Destination, completion: @escaping () -> () = {}) {
        DispatchQueue.main.async {
            self.paths[self.pathIndex].append(destination)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    public func push<Destination: Hashable>(_ destination: Destination) async {
        await withCheckedContinuation({ continuation in
            push(destination) {
                continuation.resume()
            }
        })
    }
    
    public func pop() {
        DispatchQueue.main.async {
            self.paths[self.pathIndex].removeLast()
        }
    }
    
    public func pop() async {
        await withCheckedContinuation({ continuation in
            pop()
            continuation.resume()
        })
    }
    
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
    
    public func pop(last: Int) async {
        await withCheckedContinuation({ continuation in
            pop(last: last) {
                continuation.resume()
            }
        })
    }
    
    public func popToStackRoot(completion: @escaping () -> () = {}) {
        pop(last: paths[self.pathIndex].count, completion: completion)
    }
    
    public func popToStackRoot() async {
        await withCheckedContinuation({ continuation in
            popToStackRoot {
                continuation.resume()
            }
        })
    }
    
    public func toggle(_ isPresented: Binding<Bool>, completion: @escaping () -> () = {}) {
        DispatchQueue.main.async {
            isPresented.wrappedValue.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    public func toggle(_ isPresented: Binding<Bool>) async {
        await withCheckedContinuation({ continuation in
            toggle(isPresented) {
                continuation.resume()
            }
        })
    }
    
    public func push(_ isPresented: Binding<Bool>, completion: @escaping () -> () = {}) {
        DispatchQueue.main.async {
            isPresented.wrappedValue = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    public func push(_ isPresented: Binding<Bool>) async {
        await withCheckedContinuation({ continuation in
            push(isPresented) {
                continuation.resume()
            }
        })
    }
    
    public func pop(_ isPresented: Binding<Bool>, completion: @escaping () -> () = {}) {
        DispatchQueue.main.async {
            isPresented.wrappedValue = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    public func pop(_ isPresented: Binding<Bool>) async {
        await withCheckedContinuation({ continuation in
            pop(isPresented) {
                continuation.resume()
            }
        })
    }
}
