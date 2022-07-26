//
//  NavigationRootPopover.swift
//  MultiplatformNavigation
//
//  Created by Alex Nagy on 17.07.2022.
//

import SwiftUI

public struct NavigationRootPopoverNoDestination<R>: View where R: View {
    
    @EnvironmentObject private var navigation: Navigation
    
    var path: Navigation.PopoverPath
    var attachmentAnchor: PopoverAttachmentAnchor
    var arrowEdge: Edge
    var root: () -> R
    var onDismiss: (() -> Void)?
    
    public init(path: Navigation.PopoverPath,
                attachmentAnchor: PopoverAttachmentAnchor,
                arrowEdge: Edge,
                _ root: @escaping () -> R) {
        self.path = path
        self.attachmentAnchor = attachmentAnchor
        self.arrowEdge = arrowEdge
        self.root = root
    }
    
    public var body: some View {
        EmptyView()
            .popover(isPresented: isPresented(), attachmentAnchor: attachmentAnchor, arrowEdge: arrowEdge, content: {
                root()
            })
    }
    
    func isPresented() -> Binding<Bool> {
        switch path {
        case .popover1:
            return $navigation.popover1
        case .popover2:
            return $navigation.popover2
        case .popover3:
            return $navigation.popover3
        case .popover4:
            return $navigation.popover4
        case .popover5:
            return $navigation.popover5
        case .popover6:
            return $navigation.popover6
        case .popover7:
            return $navigation.popover7
        case .popover8:
            return $navigation.popover8
        case .popover9:
            return $navigation.popover9
        case .popover10:
            return $navigation.popover10
        case .popover11:
            return $navigation.popover11
        case .popover12:
            return $navigation.popover12
        case .popover13:
            return $navigation.popover13
        case .popover14:
            return $navigation.popover14
        case .popover15:
            return $navigation.popover15
        case .popover16:
            return $navigation.popover16
        case .popover17:
            return $navigation.popover17
        case .popover18:
            return $navigation.popover18
        case .popover19:
            return $navigation.popover19
        case .popover20:
            return $navigation.popover20
        case .popover21:
            return $navigation.popover21
        case .popover22:
            return $navigation.popover22
        case .popover23:
            return $navigation.popover23
        case .popover24:
            return $navigation.popover24
        case .popover25:
            return $navigation.popover25
        case .popover26:
            return $navigation.popover26
        case .popover27:
            return $navigation.popover27
        case .popover28:
            return $navigation.popover28
        case .popover29:
            return $navigation.popover29
        case .popover30:
            return $navigation.popover30
        case .popover31:
            return $navigation.popover31
        case .popover32:
            return $navigation.popover32
        case .popover33:
            return $navigation.popover33
        case .popover34:
            return $navigation.popover34
        case .popover35:
            return $navigation.popover35
        case .popover36:
            return $navigation.popover36
        case .popover37:
            return $navigation.popover37
        case .popover38:
            return $navigation.popover38
        case .popover39:
            return $navigation.popover39
        case .popover40:
            return $navigation.popover40
        case .popover41:
            return $navigation.popover41
        case .popover42:
            return $navigation.popover42
        case .popover43:
            return $navigation.popover43
        case .popover44:
            return $navigation.popover44
        case .popover45:
            return $navigation.popover45
        case .popover46:
            return $navigation.popover46
        case .popover47:
            return $navigation.popover47
        case .popover48:
            return $navigation.popover48
        case .popover49:
            return $navigation.popover49
        case .popover50:
            return $navigation.popover50
        }
    }
}

public extension View {
    func popover<R>(_ path: Navigation.PopoverPath,
                    attachmentAnchor: PopoverAttachmentAnchor,
                    arrowEdge: Edge,
                    _ root: @escaping () -> R) -> some View where R: View {
        modifier(NavigationRootPopoverNoDestinationModifier(path: path, attachmentAnchor: attachmentAnchor, arrowEdge: arrowEdge, root))
    }
}

public struct NavigationRootPopoverNoDestinationModifier<R>: ViewModifier where R: View {
    
    var path: Navigation.PopoverPath
    var attachmentAnchor: PopoverAttachmentAnchor
    var arrowEdge: Edge
    var root: () -> R
    
    public init(path: Navigation.PopoverPath,
                attachmentAnchor: PopoverAttachmentAnchor,
                arrowEdge: Edge,
                _ root: @escaping () -> R) {
        self.path = path
        self.attachmentAnchor = attachmentAnchor
        self.arrowEdge = arrowEdge
        self.root = root
    }
    
    public func body(content: Content) -> some View {
        content
            .background(
                NavigationRootPopoverNoDestination<R>(path: path, attachmentAnchor: attachmentAnchor, arrowEdge: arrowEdge, root)
            )
    }
}

