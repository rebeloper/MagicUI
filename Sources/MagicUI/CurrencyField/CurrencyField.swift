//
//  CurrencyField.swift
//  CurrencyFieldDemo
//
//  Created by Alex Nagy on 15.07.2022.
//

import SwiftUI

public struct CurrencyField: View {
    
    @ObservedObject public var currency: Currency
    
    public init(_ currency: Currency) {
        self.currency = currency
    }
    
    public var body: some View {
        TextField(currency.title != nil ? currency.title! : "", text: currency.text())
            .currency(currency)
    }
}

