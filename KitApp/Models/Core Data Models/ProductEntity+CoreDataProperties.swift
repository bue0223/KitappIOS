//
//  ProductEntity+CoreDataProperties.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/17/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//
//

import Foundation
import CoreData


extension ProductEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductEntity> {
        return NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
    }

    @NSManaged public var category: String?
    @NSManaged public var id: String?
    @NSManaged public var image: Data?
    @NSManaged public var image_url: String?
    @NSManaged public var name: String?
    @NSManaged public var pack_price_retail: Double
    @NSManaged public var pack_price_wholesale: Double
    @NSManaged public var quantity_per_pack: Int64
    @NSManaged public var ave_weekly_packs: Int64
    @NSManaged public var ave_weekly_cartons: Int64
    @NSManaged public var ream_price_retail: Double
    @NSManaged public var ream_price_wholesale: Double
    @NSManaged public var stick_price: Double
    @NSManaged public var stick_price_wholesale: Double
    @NSManaged public var is_product: Bool
    @NSManaged public var product_order: Int64
    @NSManaged public var order: Int64
    @NSManaged public var rewards: NSSet?

}

// MARK: Generated accessors for rewards
extension ProductEntity {

    @objc(addRewardsObject:)
    @NSManaged public func addToRewards(_ value: RewardEntity)

    @objc(removeRewardsObject:)
    @NSManaged public func removeFromRewards(_ value: RewardEntity)

    @objc(addRewards:)
    @NSManaged public func addToRewards(_ values: NSSet)

    @objc(removeRewards:)
    @NSManaged public func removeFromRewards(_ values: NSSet)

}
