//
//  Currency.swift
//  CurrencyFieldDemo
//
//  Created by Alex Nagy on 15.07.2022.
//

import SwiftUI

public extension View {
    
    /// Adds a `Currency` to a `TextField`
    /// - Parameter currency: currency for the `TextField`
    func currency(_ currency: Currency) -> some View {
        self
        #if os(iOS) || os(tvOS)
            .keyboardType(currency.decimalCount == 0 ? .numberPad : .decimalPad)
        #endif
            .modifier(CurrencyFieldModifier(currency: currency))
    }
    
    /// Sets the style for currency field.
    func currencyFieldStyle<S>(_ style: S) -> some View where S: TextFieldStyle {
        self.textFieldStyle(style)
    }
    
}

public struct CurrencyFieldModifier: ViewModifier {
    
    @State public var text = ""
    public var currency: Currency
    
    public init(currency: Currency) {
        self.currency = currency
    }
    
    public func body(content: Content) -> some View {
        content
            .onReceive(currency.$string, perform: { newValue in
                text = newValue
            })
            .onChange(of: text) { newValue in
                if !newValue.isEmpty {
                    var replacedNewValue = newValue
                    if currency.decimalCount == 0 {
                        let intTextValue = Int(replacedNewValue.dropFirst(currency.currency.count)) ?? 0
                        currency.intValue = Int(intTextValue)
                        let valueString = "\(currency.intValue)"
                        currency.string = String("\(currency.currency)\(valueString)")
                    } else {
                        if newValue.contains(",") {
                            replacedNewValue = replacedNewValue.replacingOccurrences(of: ",", with: ".")
                        }
                        let textValue = Double(replacedNewValue.dropFirst(currency.currency.count)) ?? 0
                        let intTextValue = Int(textValue)
                        if Double(intTextValue) == textValue {
                            currency.value = Double(intTextValue)
                        } else {
                            currency.value = textValue.convert(maxDecimals: currency.decimalCount)
                            
                            
                            var valueString = "\(currency.value)"
                            if newValue.contains(",") {
                                valueString = valueString.replacingOccurrences(of: ".", with: ",")
                            }
                            currency.string = String("\(currency.currency)\(valueString)")
                        }
                    }
                }
                if newValue == currency.currency {
                    currency.string = ""
                }
            }
    }
}

public class Currency: ObservableObject {
    
    @Published public var string: String = ""
    @Published public var value: Double = 0.0
    @Published public var intValue: Int = 0
    
    public var currency: String
    public var title: String?
    public var decimalType: DecimalType
    public var decimalCount: Int
    
    /// Creates a `Currency` from a `Sring`
    /// - Parameter currency: currency `String`
    public init(_ currency: String, title: String? = nil, decimalType: DecimalType = .dot,  decimalCount: Int = 2) {
        self.currency = currency
        self.title = title
        self.decimalType = decimalType
        self.decimalCount = decimalCount
    }
    
    /// Creates a `Currency` from a `CurrencyType`
    /// - Parameter currency: currency `CurrencyType`
    public init(_ type: CurrencyType, title: String? = nil, decimalType: DecimalType = .dot, decimalCount: Int = 2) {
        self.currency = type.rawValue
        self.title = title
        self.decimalType = decimalType
        self.decimalCount = decimalCount
    }
    
    public enum DecimalType {
        case dot, comma
    }
    
    /// `Text` binding for the `TextField`
    public func text() -> Binding<String> {
        Binding(get: {
            self.string
        }, set: { setText in
            if setText.count == 1, setText != self.currency {
                self.string = "\(self.currency)\(setText)"
            } else {
                self.string = setText
            }
        })
    }
}

