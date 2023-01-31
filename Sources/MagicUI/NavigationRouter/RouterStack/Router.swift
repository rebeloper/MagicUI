//
//  Router.swift
//
//  Created by Alex Nagy on 19.01.2023.
//

import SwiftUI

public class Router<Destination: RouterDestination>: ObservableObject {

    @Published public var modalsState = Array(repeating: Array(repeating: false, count: 100), count: 10)
    @Published public var activeModalsIndices = [[Int]]()
    @Published public var tabSelection = 0

    @Published public var paths = Array(repeating: Array(repeating: NavigationPath(), count: 100), count: 10)
    @Published public var pathIndex = Array(repeating: 0, count: 10)

    // MARK: - push

    /// Pushes a destination onto the router stack.
    ///
    /// - Parameters:
    ///   - destination: Destination view.
    ///   - completion: Callback trigerred when the destination finished pushing.
    public func push(_ destination: Destination, completion: @escaping () -> () = {}) {
        guard pathIndex[tabSelection] < paths[tabSelection].count else { return }
        DispatchQueue.main.async {
            self.paths[self.tabSelection][self.pathIndex[self.tabSelection]].append(destination)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }

    /// Pushes a destination onto the router stack asyncronously.
    ///
    /// - Parameter destination: Destination view.
    @MainActor
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
        activeModalsIndices[tabSelection].append(destination.modalValue)
        DispatchQueue.main.async {
            self.modalsState[self.tabSelection][destination.modalValue] = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }

    /// Presents a destination as a modal on the router stack asyncronously.
    ///
    /// - Parameter destination: Destination view.
    @MainActor
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
            popOne(completion: completion)
        case .the(let last):
            popTheLast(last, style: .shortest, completion: completion)
        case .to(let index):
            popToIndex(index, style: .shortest, completion: completion)
        case .toRoot:
            popToRoot(style: .shortest, completion: completion)
        case .toNearestRoot:
            popToNearestRoot(style: .shortest, completion: completion)
        case .theLastWith(let style, let last):
            popTheLast(last, style: style, completion: completion)
        case .toIndexWith(let style, let index):
            popToIndex(index, style: style, completion: completion)
        case .toRootWith(let style):
            popToRoot(style: style, completion: completion)
        case .toNearestRootWith(let style):
            popToNearestRoot(style: style, completion: completion)
        }
    }

    /// Pops a view from the router stack asyncronously.
    ///
    /// - Parameter type: The type of the pop.
    @MainActor
    public func pop(_ type: PopType = .one) async {
        await withCheckedContinuation({ continuation in
            pop(type) {
                continuation.resume()
            }
        })
    }

    // MARK: - internal

    internal func dismiss(completion: @escaping () -> ()) {
        guard pathIndex[tabSelection] < paths[tabSelection].count, !paths[tabSelection][pathIndex[tabSelection]].isEmpty else { return }
        DispatchQueue.main.async {
            self.paths[self.tabSelection][self.pathIndex[self.tabSelection]].removeLast()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    internal func dismissStack(completion: @escaping () -> ()) {
        guard pathIndex[tabSelection] < paths[tabSelection].count, !paths[tabSelection][pathIndex[tabSelection]].isEmpty else { return }
        DispatchQueue.main.async {
            let all = self.paths[self.tabSelection][self.pathIndex[self.tabSelection]].count
            self.paths[self.tabSelection][self.pathIndex[self.tabSelection]].removeLast(all)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    internal func dismissStack(last: Int, completion: @escaping (Int) -> ()) {
        guard pathIndex[tabSelection] < paths[tabSelection].count, !paths[tabSelection][pathIndex[tabSelection]].isEmpty else { return }
        let all = self.paths[self.tabSelection][self.pathIndex[self.tabSelection]].count
        var removeLast = 0
        var left = 0
        if last >= all {
            removeLast = all
            left = last - all
        } else {
            removeLast = last
            left = 0
        }
        DispatchQueue.main.async {
            self.paths[self.tabSelection][self.pathIndex[self.tabSelection]].removeLast(removeLast)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion(left)
        })
    }

    internal func dismissModal(completion: @escaping () -> ()) {
        guard let index = activeModalsIndices[tabSelection].last else { return }
        DispatchQueue.main.async {
            self.modalsState[self.tabSelection][index] = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }

    internal func getAllViewsCount() -> Int {
        var count = 0
        paths[tabSelection].forEach { path in
            count += path.count
        }
        count += activeModalsIndices[tabSelection].count
        count -= 1
        return count
    }
    
    internal func getPaths() -> [Int] {
        var paths = [Int]()
        self.paths[tabSelection].forEach { path in
            if !path.isEmpty {
                paths.append(path.count)
            }
        }
        return paths.reversed()
    }
    
    internal func getLastPathCount() -> Int {
        paths[tabSelection][pathIndex[tabSelection]].count
    }
    
    internal func popOne(completion: @escaping () -> ()) {
        if paths[tabSelection][pathIndex[tabSelection]].count == 0 {
            dismissModal(completion: completion)
        } else {
            dismiss(completion: completion)
        }
    }
    
    internal func popTheLast(_ last: Int, style: PopStyle, completion: @escaping () -> ()) {
        switch style {
        case .oneByOne:
            for i in 0..<last {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6 * Double(i), execute: {
                    self.pop {
                        if i == last - 1 {
                            completion()
                        }
                    }
                })
            }
        case .shortest:
            guard last > 0 else {
                completion()
                return
            }
            let paths = getPaths()
            for i in 0..<paths.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6 * Double(i), execute: {
                    if self.activeModalsIndices[self.tabSelection].count > paths.count {
                        self.dismissModal {
                            let last = last - 1
                            self.popTheLast(last, style: style, completion: completion)
                        }
                    } else {
                        self.dismissStack(last: last) { left in
                            if i == paths.count - 1 {
                                completion()
                            } else {
                                self.popTheLast(left, style: style, completion: completion)
                            }
                        }
                    }
                })
            }
        }
    }
    
    internal func popToIndex(_ index: Int, style: PopStyle, completion: @escaping () -> ()) {
        let all = getAllViewsCount()
        let last = all - index
        popTheLast(last, style: style, completion: completion)
    }
    
    internal func popToRoot(style: PopStyle, completion: @escaping () -> ()) {
        let all = getAllViewsCount()
        popTheLast(all, style: style, completion: completion)
    }
    
    internal func popToNearestRoot(style: PopStyle, completion: @escaping () -> ()) {
        let last = getLastPathCount()
        popTheLast(last, style: style, completion: completion)
    }
    
}

public enum PopType {
    case one
    case the(last: Int)
    case to(index: Int)
    case toRoot
    case toNearestRoot
    case theLastWith(style: PopStyle, last: Int)
    case toIndexWith(style: PopStyle, index: Int)
    case toRootWith(style: PopStyle)
    case toNearestRootWith(style: PopStyle)
}

public enum PopStyle: String {
    case oneByOne, shortest
}
