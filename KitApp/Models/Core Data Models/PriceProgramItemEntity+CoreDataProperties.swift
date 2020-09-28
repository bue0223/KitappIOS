//
//  PriceProgramItemEntity+CoreDataProperties.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/16/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//
//

import Foundation
import CoreData


extension PriceProgramItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PriceProgramItemEntity> {
        return NSFetchRequest<PriceProgramItemEntity>(entityName: "PriceProgramItemEntity")
    }

    @NSManaged public var row: Int64
    @NSManaged public var carton_price: Double
    @NSManaged public var percentage_value: Double
    @NSManaged public var percentage_label: String?
    @NSManaged public var label: String?
    @NSManaged public var type: String?
    @NSManaged public var image: Data?
    @NSManaged public var image_url: String?
    @NSManaged public var is_shown: Int64
    @NSManaged public var is_reward: Bool
}
