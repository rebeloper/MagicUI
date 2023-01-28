//
//  SheetRouterModifier.swift
//
//  Created by Alex Nagy on 19.01.2023.
//

import SwiftUI

#if os(iOS) || os(macOS)
internal struct SheetRouterModifier<Destination: RouterDestination>: ViewModifier {
    
    @EnvironmentObject private var router: Router<Destination>
    
    internal var modal: Destination
    internal var presentationDetents: Set<PresentationDetent>
    internal var presentationDragIndicatorVisibility: Visibility
    let onDismiss: (() -> Void)?
    
    private var isPresentedIndex = 0
    
    internal init(modal: Destination,
                  presentationDetents: Set<PresentationDetent> = [],
                  presentationDragIndicator visibility: Visibility = .automatic,
                  onDismiss: (() -> Void)? = nil) {
        self.modal = modal
        self.presentationDetents = presentationDetents
        self.presentationDragIndicatorVisibility = visibility
        self.onDismiss = onDismiss
        self.isPresentedIndex = modal.modalValue
    }
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $router.modalsState[router.tabSelection][isPresentedIndex]) {
                DispatchQueue.main.async {
                    router.paths[router.tabSelection][router.pathIndex[router.tabSelection]] = NavigationPath()
                    router.activeModalsIndices[router.tabSelection].removeLast()
                    router.pathIndex[router.tabSelection] = router.activeModalsIndices[router.tabSelection][router.activeModalsIndices[router.tabSelection].count - 1]
                    onDismiss?()
                }
            } content: {
                RootNavigationStack<Destination, Destination>(pathIndex: isPresentedIndex, tabIndex: router.tabSelection, presentationDetents: presentationDetents, presentationDragIndicator: presentationDragIndicatorVisibility) {
                    modal
                }
            }
    }
}

public extension View {
    
    func sheet<Destination: RouterDestination>(for modal: Destination,
                                             presentationDetents: Set<PresentationDetent> = [],
                                             presentationDragIndicatorVisibility: Visibility = .automatic,
                                             onDismiss: (() -> Void)? = nil) -> some View {
        self.modifier(SheetRouterModifier<Destination>(modal: modal, presentationDetents: presentationDetents, presentationDragIndicator: presentationDragIndicatorVisibility, onDismiss: onDismiss))
    }
}
#endif
