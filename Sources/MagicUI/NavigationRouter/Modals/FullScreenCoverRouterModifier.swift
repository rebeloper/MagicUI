//
//  FullScreenCoverRouterModifier.swift
//
//  Created by Alex Nagy on 19.01.2023.
//

import SwiftUI

#if os(iOS) || os(watchOS)
internal struct FullScreenCoverRouterModifier<Destination: RouterDestination>: ViewModifier {
    
    @EnvironmentObject private var router: Router<Destination>
    
    internal var modal: Destination
    let onDismiss: (() -> Void)?
    
    private var isPresentedIndex = 0
    
    internal init(modal: Destination,
                  onDismiss: (() -> Void)? = nil) {
        self.modal = modal
        self.onDismiss = onDismiss
        self.isPresentedIndex = modal.modalValue
    }
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $router.modalsState[router.tabSelection][isPresentedIndex]) {
                DispatchQueue.main.async {
                    router.paths[router.tabSelection][router.pathIndex[router.tabSelection]] = NavigationPath()
                    router.activeModalsIndices[router.tabSelection].removeLast()
                    router.pathIndex[router.tabSelection] = router.activeModalsIndices[router.tabSelection][router.activeModalsIndices[router.tabSelection].count - 1]
                    onDismiss?()
                }
            } content: {
                RootNavigationStack<Destination, Destination>(pathIndex: isPresentedIndex, tabIndex: router.tabSelection) {
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
