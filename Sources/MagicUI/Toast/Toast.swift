//
//  Toast.swift
//  MagicUI
//
//  Created by Alex Nagy on 17.06.2022.
//

import SwiftUI
import Combine

fileprivate struct AnimatedCheckmark: View {
    
    ///Checkmark color
    var color: Color = .black
    
    ///Checkmark color
    var size: Int = 50
    
    var height: CGFloat {
        return CGFloat(size)
    }
    
    var width: CGFloat {
        return CGFloat(size)
    }
    
    @State private var percentage: CGFloat = .zero
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: height / 2))
            path.addLine(to: CGPoint(x: width / 2.5, y: height))
            path.addLine(to: CGPoint(x: width, y: 0))
        }
        .trim(from: 0, to: percentage)
        .stroke(color, style: StrokeStyle(lineWidth: CGFloat(size / 8), lineCap: .round, lineJoin: .round))
        .animation(Animation.spring().speed(0.75).delay(0.25), value: percentage)
        .onAppear {
            percentage = 1.0
        }
        .frame(width: width, height: height, alignment: .center)
    }
}

fileprivate struct AnimatedXmark: View {
    
    ///xmark color
    var color: Color = .black
    
    ///xmark size
    var size: Int = 50
    
    var height: CGFloat {
        return CGFloat(size)
    }
    
    var width: CGFloat {
        return CGFloat(size)
    }
    
    var rect: CGRect{
        return CGRect(x: 0, y: 0, width: size, height: size)
    }
    
    @State private var percentage: CGFloat = .zero
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxY, y: rect.maxY))
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
        .trim(from: 0, to: percentage)
        .stroke(color, style: StrokeStyle(lineWidth: CGFloat(size / 8), lineCap: .round, lineJoin: .round))
        .animation(Animation.spring().speed(0.75).delay(0.25), value: percentage)
        .onAppear {
            percentage = 1.0
        }
        .frame(width: width, height: height, alignment: .center)
    }
}

//MARK: - Main View

public struct Toast: View {
    
    ///The display mode
    /// - `alert`
    /// - `hud`
    /// - `banner`
    public var displayMode: ToastDisplayMode = .alert
    
    ///What the alert would show
    ///`complete`, `error`, `systemImage`, `image`, `loading`, `regular`
    public var type: ToastType
    
    ///The title of the alert (`Optional(String)`)
    public var title: String? = nil
    
    ///The message of the alert (`Optional(String)`)
    public var message: String? = nil
    
    ///Customize your alert appearance
    public var style: ToastStyle? = nil
    
    ///Full init
    public init(displayMode: ToastDisplayMode = .alert,
                type: ToastType,
                title: String? = nil,
                message: String? = nil,
                style: ToastStyle? = nil) {
        
        self.displayMode = displayMode
        self.type = type
        self.title = title
        self.message = message
        self.style = style
    }
    
    ///Short init with most used parameters
    public init(displayMode: ToastDisplayMode,
                type: ToastType,
                title: String? = nil) {
        
        self.displayMode = displayMode
        self.type = type
        self.title = title
    }
    
    ///Banner from the bottom of the view
    public var banner: some View {
        VStack{
            Spacer()
            
            //Banner view starts here
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    switch type {
                    case .success(let color):
                        Image(systemName: "checkmark")
                            .systemImageModifier(color: color, font: style?.systemImageFont)
                    case .error(let color):
                        Image(systemName: "xmark")
                            .systemImageModifier(color: color, font: style?.systemImageFont)
                    case .systemImage(let name, let color):
                        Image(systemName: name)
                            .systemImageModifier(color: color, font: style?.systemImageFont)
                    case .image(let name, let color):
                        Image(name)
                            .imageModifier(color: color, maxLength: style?.imageMaxLength)
                    case .loading:
                        ProgressView()
                    case .regular:
                        EmptyView()
                    }
                    
                    Text(LocalizedStringKey(title ?? ""))
                        .font(style?.titleFont ?? Font.headline.bold())
                        .textColor(style?.titleColor ?? nil)
                }
                
                if message != nil{
                    Text(LocalizedStringKey(message!))
                        .font(style?.messageFont ?? Font.subheadline)
                        .textColor(style?.messageColor ?? .gray)
                }
            }
            .multilineTextAlignment(.leading)
            .padding()
            .toastBackground(style?.backgroundColor ?? nil, backgroundMaterial: style?.backgroundMaterial ?? nil)
            .cornerRadius(style?.cornerRadius ?? 10)
            .padding([.horizontal, .bottom])
        }
    }
    
    ///HUD View
    public var hud: some View {
        Group {
            HStack(spacing: 16) {
                switch type {
                case .success(let color):
                    Image(systemName: "checkmark")
                        .systemImageModifier(color: color, font: style?.systemImageFont)
                case .error(let color):
                    Image(systemName: "xmark")
                        .systemImageModifier(color: color, font: style?.systemImageFont)
                case .systemImage(let name, let color):
                    Image(systemName: name)
                        .systemImageModifier(color: color, font: style?.systemImageFont)
                case .image(let name, let color):
                    Image(name)
                        .imageModifier(color: color, maxLength: style?.imageMaxLength)
                case .loading:
                    ProgressView()
                case .regular:
                    EmptyView()
                }
                
                if title != nil || message != nil {
                    VStack(alignment: type == .regular ? .center : .leading, spacing: 2) {
                        if title != nil {
                            Text(LocalizedStringKey(title ?? ""))
                                .font(style?.titleFont ?? Font.body.bold())
                                .textColor(style?.titleColor ?? nil)
                        }
                        if message != nil{
                            Text(LocalizedStringKey(message ?? ""))
                                .font(style?.messageFont ?? Font.footnote)
                                .textColor(style?.messageColor ?? .gray)
                        }
                    }
                }
            }
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
            .frame(minHeight: 50)
            .toastBackground(style?.backgroundColor ?? nil, backgroundMaterial: style?.backgroundMaterial ?? nil)
            .cornerRadius(style?.cornerRadius ?? 21)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 6)
            .compositingGroup()
            .padding(.horizontal)
        }
        .padding(.top)
    }
    
    ///Alert View
    public var alert: some View {
        VStack {
            switch type {
            case .success(let color):
                AnimatedCheckmark(color: color)
            case .error(let color):
                AnimatedXmark(color: color)
            case .systemImage(let name, let color):
                Image(systemName: name)
                    .systemImageModifier(color: color, font: style?.systemImageFont)
            case .image(let name, let color):
                Image(name)
                    .imageModifier(color: color, maxLength: style?.imageMaxLength)
            case .loading:
                ProgressView()
            case .regular:
                EmptyView()
            }
            
            VStack(spacing: type == .regular ? 8 : 2) {
                if title != nil{
                    Text(LocalizedStringKey(title ?? ""))
                        .font(style?.titleFont ?? Font.body.bold())
                        .textColor(style?.titleColor ?? nil)
                }
                if message != nil{
                    Text(LocalizedStringKey(message ?? ""))
                        .font(style?.messageFont ?? Font.footnote)
                        .textColor(style?.messageColor ?? .gray)
                }
            }
            .padding(.top, 10)
        }
        .multilineTextAlignment(.center)
        .padding()
        .toastBackground(style?.backgroundColor ?? nil, backgroundMaterial: style?.backgroundMaterial ?? nil)
        .cornerRadius(style?.cornerRadius ?? 10)
        .padding(.horizontal, 36)
    }
    
    ///Body init determine by `displayMode`
    public var body: some View {
        switch displayMode {
        case .alert:
            alert
        case .hud:
            hud
        case .banner:
            banner
        }
    }
}

public struct ToastModifier: ViewModifier {
    
    ///Presentation `Binding<Bool>`
    @Binding var isPresented: Bool
    
    ///Duration time to display the toast
    @State var duration: Double = 2
    
    ///Tap to dismiss toast
    @State var tapToDismiss: Bool = true
    
    var offsetY: CGFloat = 0
    
    ///Init `Toast` View
    var toast: () -> Toast
    
    ///Completion block returns `true` after dismiss
    var onTap: (() -> ())? = nil
    var completion: (() -> ())? = nil
    
    @State private var workItem: DispatchWorkItem?
    
    @State private var hostRect: CGRect = .zero
    @State private var alertRect: CGRect = .zero
    
    private var screen: CGRect {
#if os(iOS)
        return UIScreen.main.bounds
#else
        return NSScreen.main?.frame ?? .zero
#endif
    }
    
    private var offset: CGFloat {
#if os(iOS)
        return -hostRect.midY + alertRect.height
#else
        return (-hostRect.midY + screen.midY) + alertRect.height
#endif
    }
    
    @ViewBuilder
    public func main() -> some View {
        if isPresented {
            
            switch toast().displayMode {
            case .alert:
                toast()
                    .onTapGesture {
                        onTap?()
                        if tapToDismiss {
                            withAnimation(Animation.spring()) {
                                self.workItem?.cancel()
                                isPresented = false
                                self.workItem = nil
                            }
                        }
                    }
                    .onDisappear(perform: {
                        completion?()
                    })
                    .transition(AnyTransition.scale(scale: 0.8).combined(with: .opacity))
            case .hud:
                toast()
                    .overlay(
                        GeometryReader{ geo -> AnyView in
                            let rect = geo.frame(in: .global)
                            
                            if rect.integral != alertRect.integral{
                                
                                DispatchQueue.main.async {
                                    
                                    self.alertRect = rect
                                }
                            }
                            return AnyView(EmptyView())
                        }
                    )
                    .onTapGesture {
                        onTap?()
                        if tapToDismiss {
                            withAnimation(Animation.spring()) {
                                self.workItem?.cancel()
                                isPresented = false
                                self.workItem = nil
                            }
                        }
                    }
                    .onDisappear(perform: {
                        completion?()
                    })
                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
            case .banner:
                toast()
                    .onTapGesture {
                        onTap?()
                        if tapToDismiss{
                            withAnimation(Animation.spring()) {
                                self.workItem?.cancel()
                                isPresented = false
                                self.workItem = nil
                            }
                        }
                    }
                    .onDisappear(perform: {
                        completion?()
                    })
                    .transition(toast().displayMode == .banner(.slide) ? AnyTransition.slide.combined(with: .opacity) : AnyTransition.move(edge: .bottom))
            }
            
        }
    }
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        switch toast().displayMode{
        case .banner:
            content
                .overlay(ZStack{
                    main()
                        .offset(y: offsetY)
                }
                    .animation(Animation.spring(), value: isPresented)
                )
                .valueChanged(value: isPresented, onChange: { (presented) in
                    if presented{
                        onAppearAction()
                    }
                })
        case .hud:
            content
                .overlay(
                    GeometryReader { geo -> AnyView in
                        let rect = geo.frame(in: .global)
                        
                        if rect.integral != hostRect.integral {
                            DispatchQueue.main.async {
                                self.hostRect = rect
                            }
                        }
                        
                        return AnyView(EmptyView())
                    }
                        .overlay(ZStack {
                            main()
                                .offset(y: offsetY)
                        }
                            .frame(maxWidth: screen.width, maxHeight: screen.height)
                            .offset(y: offset)
                            .animation(Animation.spring(), value: isPresented))
                )
                .valueChanged(value: isPresented, onChange: { (presented) in
                    if presented {
                        onAppearAction()
                    }
                })
        case .alert:
            content
                .overlay(
                    ZStack {
                        main().offset(y: offsetY)
                    }
                        .frame(maxWidth: screen.width, maxHeight: screen.height, alignment: .center)
                        .edgesIgnoringSafeArea(.all)
                        .animation(Animation.spring(), value: isPresented))
                .valueChanged(value: isPresented, onChange: { (presented) in
                    if presented {
                        onAppearAction()
                    }
                })
        }
        
    }
    
    private func onAppearAction() {
        if toast().type == .loading {
            duration = 0
            tapToDismiss = false
        }
        
        if duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                withAnimation(Animation.spring()) {
                    isPresented = false
                    workItem = nil
                }
            }
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
        }
    }
}

///Fileprivate View Modifier to change the toast background
fileprivate struct BackgroundModifier: ViewModifier {
    
    var color: Color?
    var backgroundMaterial: BackgroundMaterial?
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if color != nil {
            content
                .background(color)
        } else if backgroundMaterial != nil {
            content
                .background(backgroundMaterial!.material())
        } else {
            content
                .background(Material.ultraThinMaterial)
        }
    }
}

///Fileprivate View Modifier to change the text colors
fileprivate struct TextForegroundModifier: ViewModifier {
    
    var color: Color?
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if color != nil {
            content
                .foregroundColor(color)
        } else {
            content
        }
    }
}

fileprivate extension Image {
    
    func imageModifier(color: Color, maxLength: CGFloat?) -> some View {
        self
            .renderingMode(color == .clear ? .original : .template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: maxLength ?? 20, maxHeight: maxLength ?? 20, alignment: .center)
            .foregroundColor(color)
    }
    
    func systemImageModifier(color: Color, font: Font?) -> some View {
        self
            .font(font)
            .foregroundColor(color)
    }
}

public extension View {
    
    func toast(isPresented: Binding<Bool>,
               duration: Double = 2,
               tapToDismiss: Bool = true,
               offsetY: CGFloat = 0,
               toast: @escaping () -> Toast,
               onTap: (() -> ())? = nil,
               completion: (() -> ())? = nil) -> some View {
        modifier(ToastModifier(isPresented: isPresented, duration: duration, tapToDismiss: tapToDismiss, offsetY: offsetY, toast: toast, onTap: onTap, completion: completion))
    }
    
    /// Choose the toast background
    /// - Parameter color: Some Color, if `nil` return `VisualEffectBlur`
    /// - Parameter backgroundMaterial: Some BackgroundMaterial, if `nil` return `VisualEffectBlur`
    /// - Returns: some View
    fileprivate func toastBackground(_ color: Color? = nil, backgroundMaterial: BackgroundMaterial? = nil) -> some View {
        modifier(BackgroundModifier(color: color, backgroundMaterial: backgroundMaterial))
    }
    
    /// Choose the toast background
    /// - Parameter color: Some Color, if `nil` return `.black`/`.white` depends on system theme
    /// - Returns: some View
    fileprivate func textColor(_ color: Color? = nil) -> some View {
        modifier(TextForegroundModifier(color: color))
    }
    
    @ViewBuilder fileprivate func valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value)) { (value) in
                onChange(value)
            }
        }
    }
}

public enum ToastBannerAnimation {
    case slide, pop
}

public enum ToastPreset {
    case progress, error, success, warning, info
}

/// Determine how the toast will be display
public enum ToastDisplayMode: Equatable {
    
    ///Present at the center of the screen
    case alert
    
    ///Drop from the top of the screen
    case hud
    
    ///Banner from the bottom of the view
    case banner(_ transition: ToastBannerAnimation)
}

/// Determine what the toast will display
public enum ToastType: Equatable {
    
    ///Animated checkmark
    case success(_ color: Color)
    
    ///Animated xmark
    case error(_ color: Color)
    
    ///System image from `SFSymbols`
    case systemImage(_ name: String, _ color: Color)
    
    ///Image from Assets
    case image(_ name: String, _ color: Color)
    
    ///Loading indicator (Circular)
    case loading
    
    ///Only text alert
    case regular
}

public enum BackgroundMaterial {
    
    /// A material that's somewhat translucent.
    case regularMaterial
    
    /// A material that's more opaque than translucent.
    case thickMaterial
    
    /// A material that's more translucent than opaque.
    case thinMaterial
    
    /// A mostly translucent material.
    case ultraThinMaterial
    
    /// A mostly opaque material.
    case ultraThickMaterial
    
    func material() -> Material {
        switch self {
        case .regularMaterial:
            return Material.regularMaterial
        case .thickMaterial:
            return Material.thickMaterial
        case .thinMaterial:
            return Material.thinMaterial
        case .ultraThinMaterial:
            return Material.ultraThinMaterial
        case .ultraThickMaterial:
            return Material.ultraThickMaterial
        }
    }
}

/// Customize Toast Appearance
public enum ToastStyle: Equatable {
    
    case style(backgroundMaterial: BackgroundMaterial? = .ultraThinMaterial,
               backgroundColor: Color? = nil,
               titleColor: Color? = nil,
               messageColor: Color? = nil,
               titleFont: Font? = nil,
               messageFont: Font? = nil,
               imageMaxLength: CGFloat? = 20,
               systemImageFont: Font? = nil,
               cornerRadius: CGFloat? = nil)
    
    ///Get background color
    var backgroundMaterial: BackgroundMaterial? {
        switch self{
        case .style(backgroundMaterial: let material, _, _, _, _, _, _, _, _):
            return material
        }
    }
    
    ///Get background color
    var backgroundColor: Color? {
        switch self{
        case .style(_, backgroundColor: let color, _, _, _, _, _, _, _):
            return color
        }
    }
    
    /// Get title color
    var titleColor: Color? {
        switch self{
        case .style(_, _, let color, _, _, _, _, _, _):
            return color
        }
    }
    
    /// Get message color
    var messageColor: Color? {
        switch self{
        case .style(_, _, _, let color, _, _, _, _, _):
            return color
        }
    }
    
    /// Get title font
    var titleFont: Font? {
        switch self {
        case .style(_, _, _, _, titleFont: let font, _, _, _, _):
            return font
        }
    }
    
    /// Get message font
    var messageFont: Font? {
        switch self {
        case .style(_, _, _, _, _, messageFont: let font, _, _, _):
            return font
        }
    }
    
    /// Get image max length font
    var imageMaxLength: CGFloat? {
        switch self {
        case .style(_, _, _, _, _, _, imageMaxLength: let length, _, _):
            return length
        }
    }
    
    /// Get systen image font
    var systemImageFont: Font? {
        switch self {
        case .style(_, _, _, _, _, _, _, systemImageFont: let font, _):
            return font
        }
    }
    
    /// Get corner radius
    var cornerRadius: CGFloat? {
        switch self {
        case .style(_, _, _, _, _, _, _, _, cornerRadius: let radius):
            return radius
        }
    }
}

/// Manages the Toasts
public class ToastManager: ObservableObject {
    @Published public var isPresented = false
    @Published public var options = ToastOptions()
    
    public init() {}
    
    /// Presents a Toast with Style
    @MainActor
    public func present(_ displayMode: ToastDisplayMode,
                        type: ToastType = .regular,
                        title: String? = nil,
                        message: String? = nil,
                        style: ToastStyle? = nil) {
        self.present(options: ToastOptions(displayMode: displayMode, type: type, title: title, message: message, style: style))
    }
    
    /// Presents a Toast with all style options
    @MainActor
    public func present(_ displayMode: ToastDisplayMode,
                        type: ToastType = .regular,
                        title: String? = nil,
                        message: String? = nil,
                        backgroundMaterial: BackgroundMaterial? = nil,
                        backgroundColor: Color? = nil,
                        titleColor: Color? = nil,
                        messageColor: Color? = nil,
                        titleFont: Font? = nil,
                        messageFont: Font? = nil,
                        imageMaxLength: CGFloat? = 20,
                        systemImageFont: Font? = nil,
                        cornerRadius: CGFloat? = nil) {
        self.present(options: ToastOptions(displayMode: displayMode, type: type, title: title, message: message, style: ToastStyle.style(backgroundMaterial: backgroundMaterial, backgroundColor: backgroundColor, titleColor: titleColor, messageColor: messageColor, titleFont: titleFont, messageFont: messageFont, imageMaxLength: imageMaxLength, systemImageFont: systemImageFont, cornerRadius: cornerRadius)))
    }
    
    /// Presents a Toast with Options
    @MainActor
    public func present(options: ToastOptions) {
        self.options = options
        withAnimation {
            isPresented = true
        }
    }
    
    /// Presents a Toast with title and message
    @MainActor
    public func present(_ displayMode: ToastDisplayMode,
                        type: ToastType = .regular,
                        title: String,
                        message: String,
                        style: ToastStyle? = nil) {
        self.present(options: ToastOptions(displayMode: displayMode, type: type, title: title, message: message, style: style))
    }
    
    /// Presents a Toast with title
    @MainActor
    public func present(_ displayMode: ToastDisplayMode,
                        type: ToastType = .regular,
                        title: String,
                        message: String? = nil,
                        style: ToastStyle? = nil) {
        self.present(options: ToastOptions(displayMode: displayMode, type: type, title: title, message: message, style: style))
    }
    
    /// Presents a Toast with sub title
    @MainActor
    public func present(_ displayMode: ToastDisplayMode,
                        type: ToastType = .regular,
                        title: String? = nil,
                        message: String,
                        style: ToastStyle? = nil) {
        self.present(options: ToastOptions(displayMode: displayMode, type: type, title: title, message: message, style: style))
    }
    
    /// Presents a Toast with a preset
    @MainActor
    public func present(_ preset: ToastPreset,
                        _ displayMode: ToastDisplayMode,
                        message: String,
                        style: ToastStyle? = nil) {
        var type: ToastType = .regular
        var title = ""
        switch preset {
        case .progress:
            type = .loading
            title = "Working"
        case .error:
            type = .error(.red)
            title = "Error"
        case .success:
            type = .success(.green)
            title = "Success"
        case .warning:
            type = .systemImage("exclamationmark.triangle.fill", .orange)
            title = "Warning"
        case .info:
            type = .systemImage("info.circle.fill", .accentColor)
            title = "Info"
        }
        
        self.present(options: ToastOptions(displayMode: displayMode, type: type, title: title, message: message, style: style))
    }
    
    /// Presents a Toast with title and message
    @MainActor
    public func present(_ displayMode: ToastDisplayMode,
                        title: String,
                        message: String,
                        style: ToastStyle? = nil) {
        self.present(options: ToastOptions(displayMode: displayMode, type: .regular, title: title, message: message, style: style))
    }
    
    /// Presents a Toast with title
    @MainActor
    public func present(_ displayMode: ToastDisplayMode,
                        title: String,
                        style: ToastStyle? = nil) {
        self.present(options: ToastOptions(displayMode: displayMode, type: .regular, title: title, message: nil, style: style))
    }
    
    /// Presents a Toast with message
    @MainActor
    public func present(_ displayMode: ToastDisplayMode,
                        message: String,
                        style: ToastStyle? = nil) {
        self.present(options: ToastOptions(displayMode: displayMode, type: .regular, title: nil, message: message, style: style))
    }
    
    /// Presents a Toast in an async throws context
    /// - Parameters:
    ///   - displayMode: the dispaly mode of the Toast
    ///   - type: the type of the Toast
    ///   - title: optional title of the Toast
    ///   - message: optional message of the Toast
    ///   - style: the style of the Toast
    ///   - alertManager: if set an error alert will be show when an `Error` is thrown
    ///   - action: action being taken while the Toast is presented
    @MainActor
    public func present(_ displayMode: ToastDisplayMode = .hud, type: ToastType = .loading, title: String? = nil, message: String? = nil, style: ToastStyle? = nil, alertManager: AlertManager? = nil, action: @escaping () async throws -> ()) async throws {
        do {
            present(options: .init(displayMode: displayMode, type: type, title: title, message: message, style: style))
            try await action()
            hide()
        } catch {
            hide()
            if let alertManager = alertManager {
                alertManager.present(error)
            }
            throw error
        }
    }
    
    /// Hides a Toast
    @MainActor
    public func hide() {
        withAnimation {
            isPresented = false
        }
    }
}

/// Optoins for the Toast
public struct ToastOptions {
    var displayMode: ToastDisplayMode = .hud
    var type: ToastType = .regular
    var title: String? = nil
    var message: String? = nil
    var style: ToastStyle? = nil
    
    public init(displayMode: ToastDisplayMode? = nil, type: ToastType? = nil, title: String? = nil, message: String? = nil, style: ToastStyle? = nil) {
        self.displayMode = displayMode ?? .hud
        self.type = type ?? .regular
        self.title = title
        self.message = message
        self.style = style
    }
}

