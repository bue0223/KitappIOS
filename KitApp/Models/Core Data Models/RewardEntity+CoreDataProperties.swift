//
//  RewardEntity+CoreDataProperties.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/17/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//
//

import Foundation
import CoreData


extension RewardEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RewardEntity> {
        return NSFetchRequest<RewardEntity>(entityName: "RewardEntity")
    }

    @NSManaged public var reward: Double
    @NSManaged public var type: String?
    @NSManaged public var owner: ProductEntity?

}
