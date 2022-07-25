//
//  MagicUIView.swift
//  MagicUI
//
//  Created by Alex Nagy on 17.06.2022.
//

import SwiftUI
import Combine

public struct MagicUIView<Content: View>: View {
    
    let content: () -> Content
    
    @StateObject private var toastManager = ToastManager()
    @StateObject private var alertManager = AlertManager()
    
    public init(content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content()
            .toast(isPresented: $toastManager.isPresented) {
                Toast(displayMode: toastManager.options.displayMode, type: toastManager.options.type, title: toastManager.options.title, message: toastManager.options.message, style: toastManager.options.style)
            }
            .environmentObject(toastManager)
            .alert(alertManager.options.title ?? "Alert", isPresented: $alertManager.isAlertPresented) {
                alertManager.actions()
            } message: {
                alertManager.message()
            }
            .confirmationDialog(alertManager.options.title ?? "", isPresented: $alertManager.isConfirmationDialogPresented, titleVisibility: alertManager.options.title == nil ? .hidden : .visible) {
                alertManager.actions()
            } message: {
                alertManager.message()
            }
            .environmentObject(alertManager)
    }
}
