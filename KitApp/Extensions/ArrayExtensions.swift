//
//  ArrayExtensions.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/23/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation

extension Array {
    func split() -> [[Element]] {
        let ct = self.count
        let half = ct / 2
        let leftSplit = self[0 ..< half]
        let rightSplit = self[half ..< ct]
        return [Array(leftSplit), Array(rightSplit)]
    }
}
