//
//  Router+Modifiers.swift
//  
//
//  Created by Alex Nagy on 28.09.2022.
//

import SwiftUI

internal struct SheetRouterModifier<D: Hashable, C: View, Root: View>: ViewModifier {
    
    @Binding internal var isPresented: Bool
    @ObservedObject internal var router: Router
    @ObservedObject internal var routes: RoutesObject
    internal var presentationDetents: Set<PresentationDetent>
    internal var presentationDragIndicatorVisibility: Visibility
    internal var data: D.Type
    @ViewBuilder internal var destination: (D) -> C
    @ViewBuilder internal var root: () -> Root
    internal var onDismiss: (() -> Void)?
    
    @State private var isPresentedIndex = 0
    
    internal init(isPresented: Binding<Bool>,
                  router: Router,
                  routes: RoutesObject,
                  presentationDetents: Set<PresentationDetent> = [],
                  presentationDragIndicator visibility: Visibility = .automatic,
                  for data: D.Type,
                  @ViewBuilder _ destination: @escaping (D) -> C,
                  @ViewBuilder root: @escaping () -> Root,
                  onDismiss: (() -> Void)? = nil) {
        self._isPresented = isPresented
        self.router = router
        self.routes = routes
        self.presentationDetents = presentationDetents
        self.presentationDragIndicatorVisibility = visibility
        self.data = data
        self.destination = destination
        self.root = root
        self.onDismiss = onDismiss
    }
    
    internal func body(content: Content) -> some View {
        content
            .sheet(isActive: $isPresented, onDismiss: {
                DispatchQueue.main.async {
                    router.pathIndex = max(0, router.pathIndex - 1)
                    isPresentedIndex = max(0, isPresentedIndex - 1)
                    onDismiss?()
                }
            }, content: {
                ModalNavigationRouter(index: isPresentedIndex + 1, presentationDetents: presentationDetents, presentationDragIndicator: presentationDragIndicatorVisibility) {
                    root()
                        .navigationDestination(for: data, destination: destination)
                }
            })
    }
}

internal struct FullScreenCoverRouterModifier<D: Hashable, C: View, Root: View>: ViewModifier {
    
    @Binding internal var isPresented: Bool
    @ObservedObject internal var router: Router
    @ObservedObject internal var routes: RoutesObject
    internal var data: D.Type
    @ViewBuilder internal var destination: (D) -> C
    @ViewBuilder internal var root: () -> Root
    internal var onDismiss: (() -> Void)?
    
    @State private var isPresentedIndex = 0
    
    internal init(isPresented: Binding<Bool>,
                  router: Router,
                  routes: RoutesObject,
                  for data: D.Type,
                  @ViewBuilder _ destination: @escaping (D) -> C,
                  @ViewBuilder root: @escaping () -> Root,
                  onDismiss: (() -> Void)? = nil) {
        self._isPresented = isPresented
        self.router = router
        self.routes = routes
        self.data = data
        self.destination = destination
        self.root = root
        self.onDismiss = onDismiss
    }
    
    internal func body(content: Content) -> some View {
        content
            .fullScreenCover(isActive: $isPresented, onDismiss: {
                DispatchQueue.main.async {
                    router.pathIndex = max(0, router.pathIndex - 1)
                    isPresentedIndex = max(0, isPresentedIndex - 1)
                    onDismiss?()
                }
            }, content: {
                ModalNavigationRouter(index: isPresentedIndex + 1) {
                    root()
                        .navigationDestination(for: data, destination: destination)
                }
            })
    }
}

internal struct SheetPublishedModifier<D: View>: ViewModifier {
    
    @State private var binding = false
    
    @Binding internal var published: Bool
    internal var onDismiss: (() -> Void)?
    @ViewBuilder internal var destination: () -> D
    
    internal init(published: Binding<Bool>,
                  onDismiss: (() -> Void)? = nil,
                  content: @escaping () -> D) {
        self._published = published
        self.onDismiss = onDismiss
        self.destination = content
    }
    
    internal func body(content: Content) -> some View {
        content
            .sync($published, with: $binding)
            .sheet(isPresented: $binding, onDismiss: onDismiss, content: destination)
    }
}

internal struct FullScreenCoverPublishedModifier<D: View>: ViewModifier {
    
    @State private var binding = false
    
    @Binding internal var published: Bool
    internal var onDismiss: (() -> Void)?
    @ViewBuilder internal var destination: () -> D
    
    internal init(published: Binding<Bool>,
                  onDismiss: (() -> Void)? = nil,
                  content: @escaping () -> D) {
        self._published = published
        self.onDismiss = onDismiss
        self.destination = content
    }
    
    internal func body(content: Content) -> some View {
        content
            .sync($published, with: $binding)
            .fullScreenCover(isPresented: $binding, onDismiss: onDismiss, content: destination)
    }
}


