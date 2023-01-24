//
//  SheetRouterModifier.swift
//
//  Created by Alex Nagy on 19.01.2023.
//

import SwiftUI

#if !os(tvOS)
internal struct SheetRouterModifier<Destination: RouterDestination>: ViewModifier {
    
    @EnvironmentObject private var routes: Routes<Destination>
    
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
            .sheet(isPresented: $routes.modalsState[routes.tabSelection][isPresentedIndex]) {
                DispatchQueue.main.async {
                    routes.paths[routes.tabSelection][routes.pathIndex[routes.tabSelection]] = NavigationPath()
                    routes.activeModalsIndices[routes.tabSelection].removeLast()
                    routes.pathIndex[routes.tabSelection] = routes.activeModalsIndices[routes.tabSelection][routes.activeModalsIndices[routes.tabSelection].count - 1]
                    onDismiss?()
                }
            } content: {
                RootNavigationStack<Destination, Destination>(pathIndex: isPresentedIndex, tabIndex: routes.tabSelection, presentationDetents: presentationDetents, presentationDragIndicator: presentationDragIndicatorVisibility) {
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
