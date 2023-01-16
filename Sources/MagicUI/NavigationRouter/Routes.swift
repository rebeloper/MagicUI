//
//  Routes.swift
//
//  Created by Alex Nagy on 04.01.2023.
//

import SwiftUI
import Combine

public enum RoutesDismissType {
    case one
    case the(last: Int)
    case to(index: Int)
    case toStackRoot
}

open class Routes<Destination: RouterDestination>: ObservableObject {
    
    @Published public var modalsState = Array(repeating: Array(repeating: false, count: 100), count: 10)  // we set 'true' for the index of the modal
    @Published public var activeModalsIndices = [[Int]]() // an array of the active modals' indices; ex. [0, 2, 6, 3]
    @Published public var tabSelection = 0
    
    
    
    @Published internal var paths = Array(repeating: Array(repeating: NavigationPath(), count: 100), count: 10)
    @Published internal var pathIndex = Array(repeating: 0, count: 10)
    
    /// Pushes a destination onto the navigation stack.
    /// - Parameters:
    ///   - destination: The type of data that this destination matches.
    ///   - completion: Optional completion trigerred after the push.
    public func push(_ destination: Destination, completion: @escaping () -> () = {}) {
        guard pathIndex[tabSelection] < paths[tabSelection].count else { return }
        DispatchQueue.main.async {
            self.paths[self.tabSelection][self.pathIndex[self.tabSelection]].append(destination)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    /// Pushes a destination onto the navigation stack.
    /// - Parameter destination: The type of data that this destination matches.
    public func push(_ destination: Destination) async {
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
    public func dismiss(_ type: RoutesDismissType = .one, completion: @escaping () -> ()) {
        switch type {
        case .one:
            dismiss(theLast: 1, completion: completion)
        case .the(let last):
            dismiss(theLast: last, completion: completion)
        case .to(let index):
            dismiss(to: index, completion: completion)
        case .toStackRoot:
            dismissToStackRoot(completion: completion)
        }
    }
    
    /// Pops one or more destinations from the end of this path according to the provided `PopType`
    /// - Parameter type: The pop type
    public func dismiss(_ type: RoutesDismissType = .one) async {
        await withCheckedContinuation({ continuation in
            dismiss(type) {
                continuation.resume()
            }
        })
    }
    
    /// Removes the last destination from the navigation stack
    private func removeLast() {
        guard pathIndex[tabSelection] < paths[tabSelection].count, !paths[tabSelection][pathIndex[tabSelection]].isEmpty else { return }
        DispatchQueue.main.async {
            self.paths[self.tabSelection][self.pathIndex[self.tabSelection]].removeLast()
        }
    }
    
    /// Pops the last destinations from the navigation stack.
    /// - Parameters:
    ///   - last: The amount of destinations to be popped.
    ///   - completion: Optional completion trigerred after the pop has finished.
    private func dismiss(theLast last: Int, completion: @escaping () -> ()) {
        for i in 0..<min(paths[tabSelection][pathIndex[tabSelection]].count, last) {
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
    private func dismiss(to index: Int, completion: @escaping () -> ()) {
        let last = paths[tabSelection][pathIndex[tabSelection]].count - index
        dismiss(theLast: last, completion: completion)
    }
    
    
    /// Pops all the destinations from the navigation stack.
    /// - Parameter completion: Optional completion trigerred after the pop has finished.
    private func dismissToStackRoot(completion: @escaping () -> ()) {
        dismiss(theLast: paths[tabSelection][pathIndex[tabSelection]].count, completion: completion)
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
    public func present(_ isActive: Binding<Bool>, completion: @escaping () -> () = {}) {
        DispatchQueue.main.async {
            isActive.wrappedValue = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    /// Presents a destination associated to the `isActive` value.
    /// - Parameter isActive: A Bool binding representing the presentation of the destination.
    public func present(_ isActive: Binding<Bool>) async {
        await withCheckedContinuation({ continuation in
            present(isActive) {
                continuation.resume()
            }
        })
    }
    
    /// Pops a destination associated to the `isActive` value.
    /// - Parameters:
    ///   - isActive: A Bool binding representing the presentation of the destination.
    ///   - completion: Optional completion trigerred after the pop has finished.
    public func dismiss(_ isActive: Binding<Bool>, completion: @escaping () -> () = {}) {
        DispatchQueue.main.async {
            isActive.wrappedValue = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            completion()
        })
    }
    
    /// Pops a destination associated to the `isActive` value.
    /// - Parameter isActive: A Bool binding representing the presentation of the destination.
    public func dismiss(_ isActive: Binding<Bool>) async {
        await withCheckedContinuation({ continuation in
            dismiss(isActive) {
                continuation.resume()
            }
        })
    }
    
}
