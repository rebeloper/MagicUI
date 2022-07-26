//
//  NavigationRootFullScreenCover.swift
//  
//
//  Created by Alex Nagy on 04.07.2022.
//

import SwiftUI

#if !os(macOS)
public struct NavigationRootFullScreenCover<R, D, C>: View where R: View, D : Hashable, C : View {
    
    @EnvironmentObject private var navigation: Navigation
    
    var path: Navigation.FullScreenCoverPath
    var root: () -> R
    let data: D.Type
    @ViewBuilder let destination: (D) -> C
    var onDismiss: (() -> Void)?
    
    public init(path: Navigation.FullScreenCoverPath,
                _ root: @escaping () -> R,
                with data: D.Type,
                @ViewBuilder destination: @escaping (D) -> C,
                onDismiss: (() -> Void)? = nil) {
        self.path = path
        self.root = root
        self.data = data
        self.destination = destination
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        EmptyView()
            .fullScreenCover(isPresented: isPresented(), onDismiss: {
                navigation.onDismiss()
                onDismiss?()
            }, content: {
                NavigationStack(path: $navigation.paths[navigation.index]) {
                    root()
                        .navigationDestination(for: data, destination: destination)
                }
            })
    }
    
    func isPresented() -> Binding<Bool> {
        switch path {
        case .fullScreenCover1:
            return $navigation.fullScreenCover1
        case .fullScreenCover2:
            return $navigation.fullScreenCover2
        case .fullScreenCover3:
            return $navigation.fullScreenCover3
        case .fullScreenCover4:
            return $navigation.fullScreenCover4
        case .fullScreenCover5:
            return $navigation.fullScreenCover5
        case .fullScreenCover6:
            return $navigation.fullScreenCover6
        case .fullScreenCover7:
            return $navigation.fullScreenCover7
        case .fullScreenCover8:
            return $navigation.fullScreenCover8
        case .fullScreenCover9:
            return $navigation.fullScreenCover9
        case .fullScreenCover10:
            return $navigation.fullScreenCover10
        case .fullScreenCover11:
            return $navigation.fullScreenCover11
        case .fullScreenCover12:
            return $navigation.fullScreenCover12
        case .fullScreenCover13:
            return $navigation.fullScreenCover13
        case .fullScreenCover14:
            return $navigation.fullScreenCover14
        case .fullScreenCover15:
            return $navigation.fullScreenCover15
        case .fullScreenCover16:
            return $navigation.fullScreenCover16
        case .fullScreenCover17:
            return $navigation.fullScreenCover17
        case .fullScreenCover18:
            return $navigation.fullScreenCover18
        case .fullScreenCover19:
            return $navigation.fullScreenCover19
        case .fullScreenCover20:
            return $navigation.fullScreenCover20
        case .fullScreenCover21:
            return $navigation.fullScreenCover21
        case .fullScreenCover22:
            return $navigation.fullScreenCover22
        case .fullScreenCover23:
            return $navigation.fullScreenCover23
        case .fullScreenCover24:
            return $navigation.fullScreenCover24
        case .fullScreenCover25:
            return $navigation.fullScreenCover25
        case .fullScreenCover26:
            return $navigation.fullScreenCover26
        case .fullScreenCover27:
            return $navigation.fullScreenCover27
        case .fullScreenCover28:
            return $navigation.fullScreenCover28
        case .fullScreenCover29:
            return $navigation.fullScreenCover29
        case .fullScreenCover30:
            return $navigation.fullScreenCover30
        case .fullScreenCover31:
            return $navigation.fullScreenCover31
        case .fullScreenCover32:
            return $navigation.fullScreenCover32
        case .fullScreenCover33:
            return $navigation.fullScreenCover33
        case .fullScreenCover34:
            return $navigation.fullScreenCover34
        case .fullScreenCover35:
            return $navigation.fullScreenCover35
        case .fullScreenCover36:
            return $navigation.fullScreenCover36
        case .fullScreenCover37:
            return $navigation.fullScreenCover37
        case .fullScreenCover38:
            return $navigation.fullScreenCover38
        case .fullScreenCover39:
            return $navigation.fullScreenCover39
        case .fullScreenCover40:
            return $navigation.fullScreenCover40
        case .fullScreenCover41:
            return $navigation.fullScreenCover41
        case .fullScreenCover42:
            return $navigation.fullScreenCover42
        case .fullScreenCover43:
            return $navigation.fullScreenCover43
        case .fullScreenCover44:
            return $navigation.fullScreenCover44
        case .fullScreenCover45:
            return $navigation.fullScreenCover45
        case .fullScreenCover46:
            return $navigation.fullScreenCover46
        case .fullScreenCover47:
            return $navigation.fullScreenCover47
        case .fullScreenCover48:
            return $navigation.fullScreenCover48
        case .fullScreenCover49:
            return $navigation.fullScreenCover49
        case .fullScreenCover50:
            return $navigation.fullScreenCover50
        }
    }
}

public struct NavigationRootFullScreenCoverWithNoDestination<R>: View where R: View {
    
    @EnvironmentObject private var navigation: Navigation
    
    var path: Navigation.FullScreenCoverPath
    var root: () -> R
    var onDismiss: (() -> Void)?
    
    public init(path: Navigation.FullScreenCoverPath,
                _ root: @escaping () -> R,
                onDismiss: (() -> Void)? = nil) {
        self.path = path
        self.root = root
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        EmptyView()
            .fullScreenCover(isPresented: isPresented(), onDismiss: {
                navigation.onDismiss()
                onDismiss?()
            }, content: {
                NavigationStack(path: $navigation.paths[navigation.index]) {
                    root()
                }
            })
    }
    
    func isPresented() -> Binding<Bool> {
        switch path {
        case .fullScreenCover1:
            return $navigation.fullScreenCover1
        case .fullScreenCover2:
            return $navigation.fullScreenCover2
        case .fullScreenCover3:
            return $navigation.fullScreenCover3
        case .fullScreenCover4:
            return $navigation.fullScreenCover4
        case .fullScreenCover5:
            return $navigation.fullScreenCover5
        case .fullScreenCover6:
            return $navigation.fullScreenCover6
        case .fullScreenCover7:
            return $navigation.fullScreenCover7
        case .fullScreenCover8:
            return $navigation.fullScreenCover8
        case .fullScreenCover9:
            return $navigation.fullScreenCover9
        case .fullScreenCover10:
            return $navigation.fullScreenCover10
        case .fullScreenCover11:
            return $navigation.fullScreenCover11
        case .fullScreenCover12:
            return $navigation.fullScreenCover12
        case .fullScreenCover13:
            return $navigation.fullScreenCover13
        case .fullScreenCover14:
            return $navigation.fullScreenCover14
        case .fullScreenCover15:
            return $navigation.fullScreenCover15
        case .fullScreenCover16:
            return $navigation.fullScreenCover16
        case .fullScreenCover17:
            return $navigation.fullScreenCover17
        case .fullScreenCover18:
            return $navigation.fullScreenCover18
        case .fullScreenCover19:
            return $navigation.fullScreenCover19
        case .fullScreenCover20:
            return $navigation.fullScreenCover20
        case .fullScreenCover21:
            return $navigation.fullScreenCover21
        case .fullScreenCover22:
            return $navigation.fullScreenCover22
        case .fullScreenCover23:
            return $navigation.fullScreenCover23
        case .fullScreenCover24:
            return $navigation.fullScreenCover24
        case .fullScreenCover25:
            return $navigation.fullScreenCover25
        case .fullScreenCover26:
            return $navigation.fullScreenCover26
        case .fullScreenCover27:
            return $navigation.fullScreenCover27
        case .fullScreenCover28:
            return $navigation.fullScreenCover28
        case .fullScreenCover29:
            return $navigation.fullScreenCover29
        case .fullScreenCover30:
            return $navigation.fullScreenCover30
        case .fullScreenCover31:
            return $navigation.fullScreenCover31
        case .fullScreenCover32:
            return $navigation.fullScreenCover32
        case .fullScreenCover33:
            return $navigation.fullScreenCover33
        case .fullScreenCover34:
            return $navigation.fullScreenCover34
        case .fullScreenCover35:
            return $navigation.fullScreenCover35
        case .fullScreenCover36:
            return $navigation.fullScreenCover36
        case .fullScreenCover37:
            return $navigation.fullScreenCover37
        case .fullScreenCover38:
            return $navigation.fullScreenCover38
        case .fullScreenCover39:
            return $navigation.fullScreenCover39
        case .fullScreenCover40:
            return $navigation.fullScreenCover40
        case .fullScreenCover41:
            return $navigation.fullScreenCover41
        case .fullScreenCover42:
            return $navigation.fullScreenCover42
        case .fullScreenCover43:
            return $navigation.fullScreenCover43
        case .fullScreenCover44:
            return $navigation.fullScreenCover44
        case .fullScreenCover45:
            return $navigation.fullScreenCover45
        case .fullScreenCover46:
            return $navigation.fullScreenCover46
        case .fullScreenCover47:
            return $navigation.fullScreenCover47
        case .fullScreenCover48:
            return $navigation.fullScreenCover48
        case .fullScreenCover49:
            return $navigation.fullScreenCover49
        case .fullScreenCover50:
            return $navigation.fullScreenCover50
        }
    }
}


public extension View {
    func fullScreenCover<R, D, C>(_ path: Navigation.FullScreenCoverPath,
                                  _ root: @escaping () -> R,
                                  with data: D.Type,
                                  @ViewBuilder destination: @escaping (D) -> C,
                                  onDismiss: (() -> Void)? = nil) -> some View where R: View, D : Hashable, C : View {
        modifier(NavigationRootFullScreenCoverModifier(path: path, root, with: data, destination: destination, onDismiss: onDismiss))
    }
    
    func fullScreenCover<R>(_ path: Navigation.FullScreenCoverPath,
                            _ root: @escaping () -> R,
                            onDismiss: (() -> Void)? = nil) -> some View where R: View {
        modifier(NavigationRootFullScreenCoverWithNoDestinationModifier(path: path, root, onDismiss: onDismiss))
    }
}

public struct NavigationRootFullScreenCoverModifier<R, D, C>: ViewModifier where R: View, D : Hashable, C : View {
    
    var path: Navigation.FullScreenCoverPath
    var root: () -> R
    let data: D.Type
    @ViewBuilder let destination: (D) -> C
    var onDismiss: (() -> Void)?
    
    public init(path: Navigation.FullScreenCoverPath,
                _ root: @escaping () -> R,
                with data: D.Type,
                @ViewBuilder destination: @escaping (D) -> C,
                onDismiss: (() -> Void)? = nil) {
        self.path = path
        self.root = root
        self.data = data
        self.destination = destination
        self.onDismiss = onDismiss
    }
    
    public func body(content: Content) -> some View {
        content
            .background(
                Group {
                    NavigationRootFullScreenCover<R, D, C>(path: path, root, with: data, destination: destination, onDismiss: onDismiss)
                }
            )
    }
}

public struct NavigationRootFullScreenCoverWithNoDestinationModifier<R>: ViewModifier where R: View {
    
    var path: Navigation.FullScreenCoverPath
    var root: () -> R
    var onDismiss: (() -> Void)?
    
    public init(path: Navigation.FullScreenCoverPath,
                _ root: @escaping () -> R,
                onDismiss: (() -> Void)? = nil) {
        self.path = path
        self.root = root
        self.onDismiss = onDismiss
    }
    
    public func body(content: Content) -> some View {
        content
            .background(
                NavigationRootFullScreenCoverWithNoDestination<R>(path: path, root, onDismiss: onDismiss)
            )
    }
}
#endif
