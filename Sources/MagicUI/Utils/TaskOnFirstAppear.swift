//
//  TaskOnFirstAppear.swift
//  
//
//  Created by Alex Nagy on 10.10.2022.
//

import SwiftUI

public struct TaskOnFirstAppearModifier<T: Equatable>: ViewModifier {
    
    @State private var onAppearCalled = false
    
    private let id: T
    private let priority: TaskPriority
    private let action: () async -> Void
    
    public init(id value: T, priority: TaskPriority = .userInitiated, _ action: @escaping @Sendable () async -> Void) {
        self.id = value
        self.priority = priority
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content
            .task(id: id, priority: priority) {
                if !onAppearCalled {
                    onAppearCalled = true
                    await action()
                }
            }
    }
}

public extension View {
    
    /// Adds a task to perform before this view appears for the first time or when a specified
    /// value changes for the first time.
    ///
    /// - Parameters:
    ///   - id: The value to observe for changes. The value must conform
    ///     to the <doc://com.apple.documentation/documentation/Swift/Equatable>
    ///     protocol.
    ///   - priority: The task priority to use when creating the asynchronous
    ///     task. The default priority is
    ///     <doc://com.apple.documentation/documentation/Swift/TaskPriority/3851283-userInitiated>.
    ///   - action: A closure that SwiftUI calls as an asynchronous task
    ///     before the view appears. SwiftUI can automatically cancel the task
    ///     after the view disappears before the action completes. If the
    ///     `id` value changes, SwiftUI cancels and restarts the task.
    ///
    /// - Returns: A view that runs the specified action asynchronously before
    ///   the view appears, or restarts the task with the `id` value changes.
    @inlinable func taskOnFirstAppear<T: Equatable>(id value: T, priority: TaskPriority = .userInitiated, _ action: @escaping @Sendable () async -> Void) -> some View {
        self.modifier(TaskOnFirstAppearModifier(id: value, priority: priority, action))
    }
}
