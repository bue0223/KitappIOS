//
//  FormatterExtensions.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 6/23/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation

extension Double {
    var formattedAmount: String {
        let rounded = self.rounded(toPlaces: 2)
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.init(identifier: "fil_PH")
        formatter.numberStyle = .currency
        return formatter.string(from: rounded as NSNumber)!
    }
}

extension Decimal {
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.init(identifier: "fil_PH") // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        formatter.numberStyle = .currency
        return formatter.string(from: self as NSNumber)!
    }
}
