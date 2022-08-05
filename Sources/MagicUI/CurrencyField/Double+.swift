//
//  Double+.swift
//  CurrencyFieldDemo
//
//  Created by Alex Nagy on 15.07.2022.
//

//
//  Double+.swift
//  MagicUI
//
//  Created by Alex Nagy on 12.07.2022.
//

import Foundation

public extension Double {
    
    /// Converts to the maximum decimals specified
    func convert(maxDecimals max: Int) -> Double {
        let stringArr = String(self).split(separator: ".")
        let decimals = Array(stringArr[1])
        var string = "\(stringArr[0])."
        
        var count = 0;
        for n in decimals {
            if count == max { break }
            string += "\(n)"
            count += 1
        }
        
        let double = Double(string)!
        return double
    }
}

