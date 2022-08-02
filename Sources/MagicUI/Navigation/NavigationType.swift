//
//  NavigationType.swift
//  MagicUI
//
//  Created by Alex Nagy on 09.08.2021.
//

import SwiftUI

@available(iOS 16, *, macOS 13.0, *, tvOS 16.0, *, watchOS 9.0, *)
public enum NavigationStyle {
    case page, sheet(detents: Set<PresentationDetent>, dragIndicator: Visibility), flexibleSheet(dragIndicator: Visibility), fullScreenCover, popover(attachmentAnchor: PopoverAttachmentAnchor, arrowEdge: Edge)
}

public enum NavigationType {
    case page, sheet, fullScreenCover, popover(attachmentAnchor: PopoverAttachmentAnchor, arrowEdge: Edge)
}
