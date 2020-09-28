//
//  PriceProgramItemEntity+CoreDataClass.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/16/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PriceProgramItemEntity)
public class PriceProgramItemEntity: NSManagedObject {
    var ownerType: String {
        if type == "RETAIL" {
            return "retailer"
        }
        
        return "wholesaler"
    }
}
