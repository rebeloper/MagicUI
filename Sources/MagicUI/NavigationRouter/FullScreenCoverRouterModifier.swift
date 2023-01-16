//
//  FullScreenCoverRouterModifier.swift
//
//  Created by Alex Nagy on 19.12.2022.
//

import SwiftUI

#if os(iOS) || os(watchOS)
internal struct FullScreenCoverRouterModifier<Destination: RouterDestination>: ViewModifier {
    
    @EnvironmentObject private var routes: Routes<Destination>
    
    internal var modal: Destination
    let onDismiss: (() -> Void)?
    
    private var isPresentedIndex = 0
    
    internal init(modal: Destination,
                  onDismiss: (() -> Void)? = nil) {
        self.modal = modal
        self.onDismiss = onDismiss
        self.isPresentedIndex = modal.rawValue
    }
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $routes.modalsState[routes.tabSelection][isPresentedIndex]) {
                DispatchQueue.main.async {
                    routes.paths[routes.tabSelection][routes.activeModalsIndices[routes.tabSelection].count - 1] = NavigationPath()
                    routes.activeModalsIndices[routes.tabSelection].removeLast()
                    onDismiss?()
                }
            } content: {
                RootNavigationStack<Destination, Destination>(pathIndex: isPresentedIndex, tabIndex: routes.tabSelection) {
                    modal
                }
            }

    }
}

public extension View {
    
    func fullScreenCover<Destination: RouterDestination>(for modal: Destination,
                                                       onDismiss: (() -> Void)? = nil) -> some View {
        self.modifier(FullScreenCoverRouterModifier<Destination>(modal: modal, onDismiss: onDismiss))
    }
}
#endif
