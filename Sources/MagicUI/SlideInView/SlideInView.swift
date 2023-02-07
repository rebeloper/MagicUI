//
//  SlideInView.swift
//  
//
//  Created by Alex Nagy on 24.01.2023.
//

#if !os(tvOS)
import SwiftUI

public struct SlideInView<Content: View, Container: View>: View {
    
    private var edge: Edge
    private var paddingPercentage: CGFloat
    private var options: SlideInViewOptions
    @ViewBuilder private var content: () -> Content
    @ViewBuilder private var container: () -> Container
    
    @StateObject private var context: SlideInViewManagerContext
    
    public init(_ edge: Edge = .leading,
                paddingPercentage: CGFloat = 0.35,
                options: SlideInViewOptions = SlideInViewOptions(),
                @ViewBuilder content: @escaping () -> Content,
                @ViewBuilder container: @escaping () -> Container) {
        self.edge = edge
        guard 0.0...1.0 ~= paddingPercentage else {
            fatalError("paddingPercentage must be between 0 and 1")
        }
        self.paddingPercentage = paddingPercentage
        self.options = options
        self.content = content
        self.container = container
        self._context = StateObject(wrappedValue: SlideInViewManagerContext())
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                container()
                    .if(options.presentationMode == .push, transform: { view in
                        view
                            .offset(x: isOffsetOrientationX() ? context.isActive ? edge == .leading ? getOffset(for: proxy) : -getOffset(for: proxy) : 0 : 0, y: !isOffsetOrientationX() ? context.isActive ? edge == .top ? getOffset(for: proxy) : -getOffset(for: proxy) : 0 : 0)
                            .animation(.easeInOut, value: context.isActive)
                    })
                
                ZStack {
                    if context.isActive {
                        options.paddingColor
                            .opacity(options.paddingColorOpacity)
                            .ignoresSafeArea()
                            .onTapGesture {
                                if options.shouldDismissUponExternalTap {
                                    context.isActive.toggle()
                                }
                            }
                        content()
                            .padding(getPaddingEdgeSet(), getPadding(for: proxy))
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: edge),
                                    removal: .move(edge: edge)
                                )
                            )
                            .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                                        .onEnded { value in
                                if options.shouldDismissUponSwipe {
                                    let horizontalAmount = value.translation.width as CGFloat
                                    let verticalAmount = value.translation.height as CGFloat
                                    
                                    if abs(horizontalAmount) > abs(verticalAmount) {
                                        if horizontalAmount < 0 {
                                            if edge == .leading {
                                                context.isActive.toggle()
                                            }
                                        } else if edge == .trailing {
                                            context.isActive.toggle()
                                        }
                                    } else {
                                        if verticalAmount < 0 {
                                            if edge == .top {
                                                context.isActive.toggle()
                                            }
                                        } else if edge == .bottom {
                                            context.isActive.toggle()
                                        }
                                    }
                                }
                                
                            })
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(.default, value: context.isActive)
            }
            .environmentObject(context)
        }
    }
}

public extension SlideInView {
    private func getPaddingEdgeSet() -> Edge.Set {
        switch edge {
        case .top:
            return .bottom
        case .leading:
            return .trailing
        case .bottom:
            return .top
        case .trailing:
            return .leading
        }
    }
    
    private func getPadding(for proxy: GeometryProxy) -> CGFloat {
        switch edge {
        case .top, .bottom:
            return proxy.size.height * paddingPercentage
        case .leading, .trailing:
            return proxy.size.width * paddingPercentage
        }
    }
    
    private func isOffsetOrientationX() -> Bool {
        edge == .leading || edge == .trailing
    }
    
    private func getOffset(for proxy: GeometryProxy) -> CGFloat {
        switch edge {
        case .top, .bottom:
            return proxy.size.height - proxy.size.height * paddingPercentage
        case .leading, .trailing:
            return proxy.size.width - proxy.size.width * paddingPercentage
        }
    }
}
#endif
