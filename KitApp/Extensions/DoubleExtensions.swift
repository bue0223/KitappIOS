//
//  DoubleExtensions.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/8/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation

public extension Double{
    func integerPart()->String{
        let result = floor(abs(self)).description.dropLast(2).description
        let plusMinus = self < 0 ? "-" : ""
        return  plusMinus + result + "."
    }
    func fractionalPart(_ withDecimalQty:Int = 2)->String{
        let valDecimal = self.truncatingRemainder(dividingBy: 1)
        let formatted = String(format: "%.\(withDecimalQty)f", valDecimal)
        let dropQuantity = self < 0 ? 3:2
        return formatted.dropFirst(dropQuantity).description
    }
    
}
