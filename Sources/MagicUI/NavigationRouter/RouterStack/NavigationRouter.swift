//
//  NavigationRouter.swift
//
//  Created by Alex Nagy on 19.01.2023.
//

import SwiftUI

public typealias Router = Int

public enum PopType {
    case one
    case the(last: Int)
    case to(index: Int)
    case toRoot
}

@propertyWrapper
public struct NavigationRouter<Destination: RouterDestination>: DynamicProperty {
    
    @EnvironmentObject var routes: Routes<Destination>
    
    public var wrappedValue: Router {
        get {
            0
        }
    }
    
    /// Navigation Router that manages router stacks.
    public init() { }
    
    // MARK: - push
    
    /// Pushes a destination onto the router stack.
    ///
    /// - Parameters:
    ///   - destination: Destination view.
    ///   - completion: Callback trigerred when the destination finished pushing.
    public func push(_ destination: Destination, completion: @escaping () -> () = {}) {
        routes.push(destination, completion: completion)
    }
    
    /// Pushes a destination onto the router stack asyncronously.
    ///
    /// - Parameter destination: Destination view.
    public func push(_ destination: Destination) async {
        await withCheckedContinuation({ continuation in
            push(destination) {
                continuation.resume()
            }
        })
    }
    
    // MARK: - present
    
    /// Presents a destination as a modal on the router stack.
    ///
    /// - Parameters:
    ///   - destination: Destination view.
    ///   - completion: Callback trigerred when the destination finished presenting.
    public func present(_ destination: Destination, completion: @escaping () -> () = {}) {
        routes.activeModalsIndices[routes.tabSelection].append(destination.rawValue)
        routes.present($routes.modalsState[routes.tabSelection][destination.rawValue], completion: completion)
    }
    
    /// Presents a destination as a modal on the router stack asyncronously.
    ///
    /// - Parameter destination: Destination view.
    public func present(_ destination: Destination) async {
        await withCheckedContinuation({ continuation in
            present(destination) {
                continuation.resume()
            }
        })
    }
    
    // MARK: - pop
    
    /// Pops a view from the router stack.
    ///
    /// - Parameters:
    ///   - type: The type of the pop.
    ///   - completion: Callback trigerred when the destination finished popping.
    public func pop(_ type: PopType = .one, completion: @escaping () -> () = {}) {
        switch type {
        case .one:
            if routes.paths[routes.tabSelection][routes.pathIndex[routes.tabSelection]].count == 0 {
                dismissModal(completion: completion)
            } else {
                dismiss(completion: completion)
            }
        case .the(let last):
            for i in 0..<last {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6 * Double(i), execute: {
                    self.pop {
                        if i == last - 1 {
                            completion()
                        }
                    }
                })
            }
        case .to(let index):
            let all = getAllViewsCount()
            let last = all - index
            pop(.the(last: last), completion: completion)
        case .toRoot:
            let all = getAllViewsCount()
            let last = all
            pop(.the(last: last), completion: completion)
        }
    }
    
    /// Pops a view from the router stack asyncronously.
    ///
    /// - Parameter type: The type of the pop.
    public func pop(_ type: PopType = .one) async {
        await withCheckedContinuation({ continuation in
            pop(type) {
                continuation.resume()
            }
        })
    }
    
    // MARK: - internal
    
    internal func dismiss(completion: @escaping () -> ()) {
        routes.dismiss(completion: completion)
    }
    
    internal func dismissModal(completion: @escaping () -> () = {}) {
        guard let index = routes.activeModalsIndices[routes.tabSelection].last else { return }
        routes.dismissModal($routes.modalsState[routes.tabSelection][index], completion: completion)
    }
    
    internal func getAllViewsCount() -> Int {
        var count = 0
        routes.paths[routes.tabSelection].forEach { path in
            count += path.count
        }
//        count += routes.activeModalsIndices[routes.tabSelection].count
//        count -= 1
        print(count)
        return count
    }
}


