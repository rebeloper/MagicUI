//
//  Double+.swift
//  MagicUI
//
//  Created by Alex Nagy on 12.07.2022.
//

import Foundation

public extension Double {
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    /// Gives back a String with decimal with places value
    func toDecimalString(withPlaces places: Int) -> String {
        String(format: "%.\(places)f", self)
    }
    
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
