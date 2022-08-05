//
//  NavigationViewModifier.swift
//  MagicUI
//
//  Created by Alex Nagy on 09.08.2021.
//

import SwiftUI

public struct NavigationViewModifier: ViewModifier {
    
    @ObservedObject public var navigation: Navigation
    @State public var tag = Int.max
    @State private var felxibleSheetSize: CGSize = .zero
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var navigationManager: NavigationManager
    
    public func body(content: Content) -> some View {
        content
            .background(
                NavigationLink_Available(navigation: navigation)
                    .onDisappear {
                        navigation.onDismiss?()
                    }
            )
            .sheet(isPresented: $navigation.isPresented, onDismiss: {
                popIfNeeded {
                    navigation.onDismiss?()
                }
            }, content: {
                if #available(iOS 16, *, macOS 13.0, *, tvOS 16.0, *, watchOS 9.0, *) {
                    // SwiftUI 4
                    navigation.destination
                        .presentationDetents(navigation.detents)
                        .presentationDragIndicator(navigation.dragIndicator)
                } else {
                    // SwiftUI 3, 2 and 1
                    navigation.destination
                }
            })
            .sheet(isPresented: $navigation.isFlexiblePresented, onDismiss: {
                popIfNeeded {
                    navigation.onDismiss?()
                }
            }, content: {
                if #available(iOS 16, *, macOS 13.0, *, tvOS 16.0, *, watchOS 9.0, *) {
                    // SwiftUI 4
                    navigation.destination
                        .readSize { size in
                            felxibleSheetSize = size
                        }
                        .presentationDetents([.height(felxibleSheetSize.height)])
                        .presentationDragIndicator(navigation.dragIndicator)
                } else {
                    // SwiftUI 3, 2 and 1
                    navigation.destination
                }
            })
            .fullScreenCover(isPresented: $navigation.isCovered, onDismiss: {
                popIfNeeded {
                    navigation.onDismiss?()
                }
            }, content: {
                navigation.destination
            })
            .popover(isPresented: $navigation.isPoppedOver, attachmentAnchor: navigation.attachmentAnchor, arrowEdge: navigation.arrowEdge, content: {
                navigation.destination
            })
            .onReceive(navigation.$dismiss) { dismiss in
                if dismiss {
                    self.dismiss()
                }
            }
            .onReceive(navigation.$tagToPopTo) { tagToPopTo in
                guard tagToPopTo != Int.max else { return }
                if navigationManager.tagToPopTo != tagToPopTo {
                    navigationManager.tagToPopTo = tagToPopTo
                }
                if tag != tagToPopTo {
                    navigationManager.isPopping = true
                    dismiss()
                }
            }
            .onAppear {
                popIfNeeded {
                    navigation.onDismiss?()
                }
            }
    }
    
    func popIfNeeded(completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            if navigationManager.isPopping {
                if tag != navigationManager.tagToPopTo {
                    dismiss()
                } else {
                    navigationManager.isPopping = false
                    navigationManager.tagToPopTo = Int.max
                }
            }
            completion()
        })
    }
}

public extension View {
    func tag(_ navigation: Navigation, with tag: Int) -> some View {
        modifier(NavigationViewModifier(navigation: navigation, tag: tag))
    }
}
