//
//  MultiItemPicker.swift
//  
//
//  Created by Alex Nagy on 14.10.2022.
//

import SwiftUI

public struct MultiItemPicker<T: Hashable, C: View, L: View, P: View, U: View, B: View>: View {
    
    @Binding private var data: [T]
    @Binding private var selected: [T]
    private var options: MultiItemPickerOptions
    private var rowBackground: B?
    @ViewBuilder private var content: (T) -> C
    @ViewBuilder private var pickedIcon: () -> P
    @ViewBuilder private var unpickedIcon: () -> U
    @ViewBuilder private var label: () -> L
    
    @State private var isAllSelected = false
    
    /// A List that lets you pick multiple items
    /// - Parameters:
    ///   - data: all the available items
    ///   - selected: the selected items
    ///   - options: picker options
    ///   - rowBackground: row background
    ///   - content: content for the row
    ///   - pickedIcon: picked icon
    ///   - unpickedIcon: unpicked icon
    ///   - label: label for the picker
    public init(_ data: Binding<[T]>,
                selected: Binding<[T]>,
                options: MultiItemPickerOptions = .init(),
                rowBackground: B? = nil,
                @ViewBuilder content: @escaping (T) -> C,
                @ViewBuilder pickedIcon: @escaping () -> P,
                @ViewBuilder unpickedIcon: @escaping () -> U,
                @ViewBuilder label: @escaping () -> L) {
        self._data = data
        self._selected = selected
        self.options = options
        self.rowBackground = rowBackground
        self.content = content
        self.pickedIcon = pickedIcon
        self.unpickedIcon = unpickedIcon
        self.label = label
    }
 
    public var body: some View {
        List {
            Section {
                ForEach(data, id: \.self) { item in
                    Button {
                        if selected.contains(item) {
                            selected.removeAll(where: { $0 == item })
                        } else {
                            selected.append(item)
                        }
                    } label: {
                        HStack {
                            switch options.iconAlignment {
                            case .leading:
                                if selected.contains(item) {
                                    pickedIcon()
                                } else {
                                    unpickedIcon()
                                }
                                content(item)
                                
                            case .trailing:
                                content(item)
                                Spacer()
                                if selected.contains(item) {
                                    pickedIcon()
                                } else {
                                    unpickedIcon()
                                }
                            }
                        }
                    }
                }
            } header: {
                HStack {
                    label()
                    if options.showsAllToggle {
                        Spacer()
                        Toggle(isOn: $isAllSelected) {
                            Text(isAllSelected ? "Unselect all" : "Select all")
                        }
                        .toggleStyle(.button)
                        .buttonStyle(.plain)
                        .foregroundColor(.accentColor)
                        .onChange(of: isAllSelected) { isAllSelected in
                            if isAllSelected {
                                selected = data
                            } else if selected.count == data.count {
                                selected.removeAll()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
            .if(options.rowSeparatorVisibility == .automatic, transform: { list in
                list.listRowSeparator(.automatic)
            }).if(options.rowSeparatorVisibility == .visible, transform: { list in
                list.listRowSeparator(.visible)
            }).if(options.rowSeparatorVisibility == .hidden, transform: { list in
                list.listRowSeparator(.hidden)
            }).if(options.rowSeparatorTint != nil, transform: { list in
                list.listRowSeparatorTint(options.rowSeparatorTint!.color, edges: options.rowSeparatorTint!.edges)
            }).if(options.rowInsets != nil, transform: { list in
                list.listRowInsets(options.rowInsets!)
            }).if(rowBackground != nil, transform: { list in
                list.listRowBackground(rowBackground)
            })
        }
        .onChange(of: selected) { selectedItems in
            if selectedItems.count == data.count {
                isAllSelected = true
            } else if selectedItems.count == data.count - 1 {
                isAllSelected = false
            }
        }
        .if(options.style == .automatic, transform: { list in
            list.listStyle(.automatic)
        }).if(options.style == .sidebar, transform: { list in
            list.listStyle(.sidebar)
        }).if(options.style == .insetGrouped, transform: { list in
            list.listStyle(.insetGrouped)
        }).if(options.style == .grouped, transform: { list in
            list.listStyle(.grouped)
        }).if(options.style == .inset, transform: { list in
            list.listStyle(.inset)
        }).if(options.style == .plain, transform: { list in
            list.listStyle(.plain)
        })
    }
}

// MARK: - init extensions

public extension MultiItemPicker where B == EmptyView {
    /// A List that lets you pick multiple items
    /// - Parameters:
    ///   - data: all the available items
    ///   - selected: the selected items
    ///   - options: picker options
    ///   - content: content for the row
    ///   - pickedIcon: picked icon
    ///   - unpickedIcon: unpicked icon
    ///   - label: label for the picker
    init(_ data: Binding<[T]>,
         selected: Binding<[T]>,
         options: MultiItemPickerOptions = .init(),
         @ViewBuilder content: @escaping (T) -> C,
         @ViewBuilder pickedIcon: @escaping () -> P,
         @ViewBuilder unpickedIcon: @escaping () -> U,
         @ViewBuilder label: @escaping () -> L) {
        self._data = data
        self._selected = selected
        self.options = options
        self.rowBackground = nil
        self.content = content
        self.pickedIcon = pickedIcon
        self.unpickedIcon = unpickedIcon
        self.label = label
    }
}

public extension MultiItemPicker where B == EmptyView, L == EmptyView {
    /// A List that lets you pick multiple items
    /// - Parameters:
    ///   - data: all the available items
    ///   - selected: the selected items
    ///   - options: picker options
    ///   - content: content for the row
    ///   - pickedIcon: picked icon
    ///   - unpickedIcon: unpicked icon
    init(_ data: Binding<[T]>,
         selected: Binding<[T]>,
         options: MultiItemPickerOptions = .init(),
         @ViewBuilder content: @escaping (T) -> C,
         @ViewBuilder pickedIcon: @escaping () -> P,
         @ViewBuilder unpickedIcon: @escaping () -> U) {
        self._data = data
        self._selected = selected
        self.options = options
        self.rowBackground = nil
        self.content = content
        self.pickedIcon = pickedIcon
        self.unpickedIcon = unpickedIcon
        self.label = { EmptyView() }
    }
}

public extension MultiItemPicker where B == EmptyView, U == EmptyView {
    /// A List that lets you pick multiple items
    /// - Parameters:
    ///   - data: all the available items
    ///   - selected: the selected items
    ///   - options: picker options
    ///   - content: content for the row
    ///   - icon: picked icon
    ///   - label: label for the picker
    init(_ data: Binding<[T]>,
         selected: Binding<[T]>,
         options: MultiItemPickerOptions = .init(),
         @ViewBuilder content: @escaping (T) -> C,
         @ViewBuilder icon pickedIcon: @escaping () -> P,
         @ViewBuilder label: @escaping () -> L) {
        self._data = data
        self._selected = selected
        self.options = options
        self.rowBackground = nil
        self.content = content
        self.pickedIcon = pickedIcon
        self.unpickedIcon = { EmptyView() }
        self.label = label
    }
}

public extension MultiItemPicker where B == EmptyView, L == EmptyView, U == EmptyView {
    /// A List that lets you pick multiple items
    /// - Parameters:
    ///   - data: all the available items
    ///   - selected: the selected items
    ///   - options: picker options
    ///   - content: content for the row
    ///   - icon: picked icon
    init(_ data: Binding<[T]>,
         selected: Binding<[T]>,
         options: MultiItemPickerOptions = .init(),
         @ViewBuilder content: @escaping (T) -> C,
         @ViewBuilder icon pickedIcon: @escaping () -> P) {
        self._data = data
        self._selected = selected
        self.options = options
        self.rowBackground = nil
        self.content = content
        self.pickedIcon = pickedIcon
        self.unpickedIcon = { EmptyView() }
        self.label = { EmptyView() }
    }
}

public extension MultiItemPicker where L == EmptyView {
    /// A List that lets you pick multiple items
    /// - Parameters:
    ///   - data: all the available items
    ///   - selected: the selected items
    ///   - options: picker options
    ///   - rowBackground: row background
    ///   - content: content for the row
    ///   - pickedIcon: picked icon
    ///   - unpickedIcon: unpicked icon
    init(_ data: Binding<[T]>,
         selected: Binding<[T]>,
         options: MultiItemPickerOptions = .init(),
         rowBackground: B? = nil,
         @ViewBuilder content: @escaping (T) -> C,
         @ViewBuilder pickedIcon: @escaping () -> P,
         @ViewBuilder unpickedIcon: @escaping () -> U) {
        self._data = data
        self._selected = selected
        self.options = options
        self.rowBackground = rowBackground
        self.content = content
        self.pickedIcon = pickedIcon
        self.unpickedIcon = unpickedIcon
        self.label = { EmptyView() }
    }
}

public extension MultiItemPicker where U == EmptyView {
    /// A List that lets you pick multiple items
    /// - Parameters:
    ///   - data: all the available items
    ///   - selected: the selected items
    ///   - options: picker options
    ///   - rowBackground: row background
    ///   - content: content for the row
    ///   - icon: picked icon
    ///   - label: label for the picker
    init(_ data: Binding<[T]>,
         selected: Binding<[T]>,
         options: MultiItemPickerOptions = .init(),
         rowBackground: B? = nil,
         @ViewBuilder content: @escaping (T) -> C,
         @ViewBuilder icon pickedIcon: @escaping () -> P,
         @ViewBuilder label: @escaping () -> L) {
        self._data = data
        self._selected = selected
        self.options = options
        self.rowBackground = rowBackground
        self.content = content
        self.pickedIcon = pickedIcon
        self.unpickedIcon = { EmptyView() }
        self.label = label
    }
}

public extension MultiItemPicker where L == EmptyView, U == EmptyView {
    /// A List that lets you pick multiple items
    /// - Parameters:
    ///   - data: all the available items
    ///   - selected: the selected items
    ///   - options: picker options
    ///   - rowBackground: row background
    ///   - content: content for the row
    ///   - icon: picked icon
    init(_ data: Binding<[T]>,
         selected: Binding<[T]>,
         options: MultiItemPickerOptions = .init(),
         rowBackground: B? = nil,
         @ViewBuilder content: @escaping (T) -> C,
         @ViewBuilder icon pickedIcon: @escaping () -> P) {
        self._data = data
        self._selected = selected
        self.options = options
        self.rowBackground = rowBackground
        self.content = content
        self.pickedIcon = pickedIcon
        self.unpickedIcon = { EmptyView() }
        self.label = { EmptyView() }
    }
}


