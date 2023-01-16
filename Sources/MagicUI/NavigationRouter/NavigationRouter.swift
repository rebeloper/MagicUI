//
//  NavigationRouter.swift
//
//  Created by Alex Nagy on 03.01.2023.
//

import SwiftUI

@propertyWrapper
public struct NavigationRouter<Destination: RouterDestination>: DynamicProperty {
    
    @EnvironmentObject var routes: Routes<Destination>
    
    public var wrappedValue: Router {
        get {
            0
        }
    }
    
    public init() { }
    
    public func push(_ destination: Destination, completion: @escaping () -> () = {}) {
        routes.push(destination, completion: completion)
    }
    
    public func push(_ destination: Destination) async {
        await routes.push(destination)
    }
    
    public func switchRoot(to destination: Destination, completion: @escaping () -> () = {}) {
        routes.switchRoot(to: destination, completion: completion)
    }
    
    public func switchRoot(to destination: Destination) async {
        await routes.switchRoot(to: destination)
    }
    
    #if !os(tvOS)
    public func present(_ destination: Destination, completion: @escaping () -> () = {}) {
        routes.activeModalsIndices[routes.tabSelection].append(destination.rawValue)
        routes.present($routes.modalsState[routes.tabSelection][destination.rawValue], completion: completion)
    }
    #endif
    
    #if !os(tvOS)
    public func present(_ destination: Destination) async {
        routes.activeModalsIndices[routes.tabSelection].append(destination.rawValue)
        await routes.present($routes.modalsState[routes.tabSelection][destination.rawValue])
    }
    #endif
    
    func dismiss(_ type: RoutesDismissType = .one, completion: @escaping () -> ()) {
        routes.dismiss(type, completion: completion)
    }
    
    func dismiss(_ type: RoutesDismissType = .one) async {
        return await routes.dismiss(type)
    }
    
    func dismissRoot(completion: @escaping () -> () = {}) {
        guard let index = routes.activeModalsIndices[routes.tabSelection].last else { return }
        routes.dismiss($routes.modalsState[routes.tabSelection][index], completion: completion)
    }
    
    func dismissRoot() async {
        guard let index = routes.activeModalsIndices[routes.tabSelection].last else { return }
        await routes.dismiss($routes.modalsState[routes.tabSelection][index])
    }
    
    public func pop(_ type: PopType = .one, completion: @escaping () -> () = {}) {
        switch type {
        case .one:
            if routes.paths[routes.tabSelection][routes.pathIndex[routes.tabSelection]].count == 0 {
                dismissRoot(completion: completion)
            } else {
                dismiss(.one, completion: completion)
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
    
    public func pop(_ type: PopType = .one) async {
        await withCheckedContinuation({ continuation in
            pop(type) {
                continuation.resume()
            }
        })
    }
    
    func getAllViewsCount() -> Int {
        var count = 0
        routes.paths[routes.tabSelection].forEach { path in
            count += path.count
        }
        count += routes.activeModalsIndices[routes.tabSelection].count
        count -= 1
        return count
    }
}

