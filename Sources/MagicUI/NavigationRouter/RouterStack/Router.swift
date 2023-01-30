////
////  Router.swift
////
////  Created by Alex Nagy on 19.01.2023.
////
//
//import SwiftUI
//
//public enum PopType {
//    case one
//    case the(last: Int)
//    case to(index: Int)
//    case toRoot
//}
//
//public class Router<Destination: RouterDestination>: ObservableObject {
//
//    @Published public var modalsState = Array(repeating: Array(repeating: false, count: 100), count: 10)
//    @Published public var activeModalsIndices = [[Int]]()
//    @Published public var tabSelection = 0
//
//    @Published public var paths = Array(repeating: Array(repeating: NavigationPath(), count: 100), count: 10)
//    @Published public var pathIndex = Array(repeating: 0, count: 10)
//
//
//    // MARK: - push
//
//    /// Pushes a destination onto the router stack.
//    ///
//    /// - Parameters:
//    ///   - destination: Destination view.
//    ///   - completion: Callback trigerred when the destination finished pushing.
//    public func push(_ destination: Destination, completion: @escaping () -> () = {}) {
//        guard pathIndex[tabSelection] < paths[tabSelection].count else { return }
//        DispatchQueue.main.async {
//            self.paths[self.tabSelection][self.pathIndex[self.tabSelection]].append(destination)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
//            completion()
//        })
//    }
//
//    /// Pushes a destination onto the router stack asyncronously.
//    ///
//    /// - Parameter destination: Destination view.
//    @MainActor
//    public func push(_ destination: Destination) async {
//        await withCheckedContinuation({ continuation in
//            push(destination) {
//                continuation.resume()
//            }
//        })
//    }
//
//    // MARK: - present
//
//    /// Presents a destination as a modal on the router stack.
//    ///
//    /// - Parameters:
//    ///   - destination: Destination view.
//    ///   - completion: Callback trigerred when the destination finished presenting.
//    public func present(_ destination: Destination, completion: @escaping () -> () = {}) {
//        activeModalsIndices[tabSelection].append(destination.modalValue)
//        DispatchQueue.main.async {
//            self.modalsState[self.tabSelection][destination.modalValue] = true
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
//            completion()
//        })
//    }
//
//    /// Presents a destination as a modal on the router stack asyncronously.
//    ///
//    /// - Parameter destination: Destination view.
//    @MainActor
//    public func present(_ destination: Destination) async {
//        await withCheckedContinuation({ continuation in
//            present(destination) {
//                continuation.resume()
//            }
//        })
//    }
//
//    // MARK: - pop
//
//    /// Pops a view from the router stack.
//    ///
//    /// - Parameters:
//    ///   - type: The type of the pop.
//    ///   - completion: Callback trigerred when the destination finished popping.
//    public func pop(_ type: PopType = .one, completion: @escaping () -> () = {}) {
//        switch type {
//        case .one:
//            if paths[tabSelection][pathIndex[tabSelection]].count == 0 {
//                dismissModal(completion: completion)
//            } else {
//                dismiss(completion: completion)
//            }
//        case .the(let last):
//            for i in 0..<last {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6 * Double(i), execute: {
//                    self.pop {
//                        if i == last - 1 {
//                            completion()
//                        }
//                    }
//                })
//            }
//        case .to(let index):
//            let all = getAllViewsCount()
//            let last = all - index
//            pop(.the(last: last), completion: completion)
//        case .toRoot:
//            let all = getAllViewsCount()
//            let last = all
//            pop(.the(last: last), completion: completion)
//        }
//    }
//
//    /// Pops a view from the router stack asyncronously.
//    ///
//    /// - Parameter type: The type of the pop.
//    @MainActor
//    public func pop(_ type: PopType = .one) async {
//        await withCheckedContinuation({ continuation in
//            pop(type) {
//                continuation.resume()
//            }
//        })
//    }
//
//    // MARK: - internal
//
//    internal func dismiss(completion: @escaping () -> ()) {
//        guard pathIndex[tabSelection] < paths[tabSelection].count, !paths[tabSelection][pathIndex[tabSelection]].isEmpty else { return }
//        DispatchQueue.main.async {
//            self.paths[self.tabSelection][self.pathIndex[self.tabSelection]].removeLast()
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
//            completion()
//        })
//    }
//
//    internal func dismissModal(completion: @escaping () -> () = {}) {
//        guard let index = activeModalsIndices[tabSelection].last else { return }
//        DispatchQueue.main.async {
//            self.modalsState[self.tabSelection][index] = false
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
//            completion()
//        })
//    }
//
//    internal func getAllViewsCount() -> Int {
//        var count = 0
//        paths[tabSelection].forEach { path in
//            count += path.count
//        }
//        count += activeModalsIndices[tabSelection].count
//        count -= 1
//        return count
//    }
//
//}
//


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
        case .the(let last, let style):
            popTheLast(last, style: style, completion: completion)
        case .to(let index, let style):
            popToIndex(index, style: style, completion: completion)
        case .toRoot(let style):
            popToRoot(style: style, completion: completion)
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
    
    
    
    internal func popOne(completion: @escaping () -> ()) {
        if paths[tabSelection][pathIndex[tabSelection]].count == 0 {
            dismissModal(completion: completion)
        } else {
            dismiss(completion: completion)
        }
    }
    
    internal func popTheLast(_ last: Int, style: PopStyle, completion: @escaping () -> ()) {
        guard last > 1 else {
            fatalError("Using pop(.the(last(\(last)), style: .\(style.rawValue), please use pop() instead.")
        }
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
            print("")
        }
    }
    
    internal func  popToIndex(_ index: Int, style: PopStyle, completion: @escaping () -> ()) {
        switch style {
        case .oneByOne:
            let all = getAllViewsCount()
            let last = all - index
            popTheLast(last, style: style, completion: completion)
        case .shortest:
            print("")
        }
    }
    
    internal func popToRoot(style: PopStyle, completion: @escaping () -> ()) {
        switch style {
        case .oneByOne:
            let all = getAllViewsCount()
            popTheLast(all, style: style, completion: completion)
        case .shortest:
            let pathsCount = getPathsCount()
            print(pathsCount)
            for i in 0..<pathsCount.count {
                if pathsCount.count == 1 {
                    print(self.activeModalsIndices[self.tabSelection])
                    if self.activeModalsIndices[self.tabSelection].count > pathsCount.count {
                        self.dismissModal {
                            self.dismissStack(completion: completion)
                        }
                    } else {
                        self.dismissStack(completion: completion)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2 * Double(i), execute: {
                        print(self.activeModalsIndices[self.tabSelection])
                        self.dismissStack {
                            if i == pathsCount.count - 1 {
                                completion()
                            } else {
                                self.dismissModal(completion: completion)
                            }
                        }
                    })
                }
            }
        }
    }
    
    internal func getPathsCount() -> [Int] {
        var pathsCount = [Int]()
        paths[tabSelection].forEach { path in
            if !path.isEmpty {
                print(path.count)
                pathsCount.append(path.count)
            }
        }
        return pathsCount.reversed()
    }
    
}

public enum PopType {
    case one
    case the(last: Int, style: PopStyle)
    case to(index: Int, style: PopStyle)
    case toRoot(style: PopStyle)
}

public enum PopStyle: String {
    case oneByOne, shortest
}
