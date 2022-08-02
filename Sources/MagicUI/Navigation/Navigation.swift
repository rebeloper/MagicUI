//
//  Navigation.swift
//  MagicUI
//
//  Created by Alex Nagy on 09.08.2021.
//

import SwiftUI

public class Navigation: ObservableObject {
    
    public init() {}
    
    @Published public var isPushed = false
    @Published public var isPresented = false
    @Published public var isFlexiblePresented = false
    @Published public var isCovered = false
    @Published public var isPoppedOver = false
    @Published public var destination: AnyView?
    @Published public var onDismiss: (() -> Void)?
    
    @available(iOS 16, *, macOS 13.0, *, tvOS 16.0, *, watchOS 9.0, *)
    @Published public var detents: Set<PresentationDetent> = []
    @Published public var dragIndicator: Visibility = .visible
    
    @Published public var dismiss = false
    @Published public var tagToPopTo = Int.max
    
    @Published public var attachmentAnchor: PopoverAttachmentAnchor = .rect(.bounds)
    @Published public var arrowEdge: Edge = .top
    
    @available(iOS, introduced: 14.0, deprecated: 16.0, message: "use push(_ style:destination:onDismiss:)")
    @available(macOS, introduced: 11.0, deprecated: 13.0, message: "use push(_ style:destination:onDismiss:)")
    @available(tvOS, introduced: 14.0, deprecated: 16.0, message: "use push(_ style:destination:onDismiss:)")
    @available(watchOS, introduced: 7.0, deprecated: 9.0, message: "use push(_ style:destination:onDismiss:)")
    public func present<Destination: View>(_ type: NavigationType, @ViewBuilder destination: () -> (Destination), onDismiss: (() -> Void)? = nil) {
        self.destination = AnyView(destination())
        switch type {
        case .page:
            self.onDismiss = onDismiss
            isPushed = true
        case .sheet:
            self.onDismiss = onDismiss
            isPresented = true
        case .popover(let attachmentAnchor, let arrowEdge):
            self.onDismiss = onDismiss
            self.attachmentAnchor = attachmentAnchor
            self.arrowEdge = arrowEdge
            isPoppedOver = true
        case .fullScreenCover:
            self.onDismiss = onDismiss
            isCovered = true
        }
    }
    
    @available(iOS 16, *, macOS 13.0, *, tvOS 16.0, *, watchOS 9.0, *)
    public func push<Destination: View>(_ style: NavigationStyle, @ViewBuilder destination: () -> (Destination), onDismiss: (() -> Void)? = nil) {
        self.destination = AnyView(destination())
        switch style {
        case .page:
            self.onDismiss = onDismiss
            isPushed = true
        case .sheet(let detents, let dragIndicator):
            self.onDismiss = onDismiss
            self.detents = detents
            self.dragIndicator = dragIndicator
            isPresented = true
        case .flexibleSheet(let dragIndicator):
            self.onDismiss = onDismiss
            self.dragIndicator = dragIndicator
            isFlexiblePresented = true
        case .popover(let attachmentAnchor, let arrowEdge):
            self.onDismiss = onDismiss
            self.attachmentAnchor = attachmentAnchor
            self.arrowEdge = arrowEdge
            isPoppedOver = true
        case .fullScreenCover:
            self.onDismiss = onDismiss
            isCovered = true
        
        }
    }
    
    func pop() {
        dismiss.toggle()
    }
    
    func pop(to tag: Int) {
        tagToPopTo = tag
    }
    
}
