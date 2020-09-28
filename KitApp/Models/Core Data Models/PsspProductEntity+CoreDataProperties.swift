//
//  PsspProductEntity+CoreDataProperties.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/12/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//
//

import Foundation
import CoreData


extension PsspProductEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PsspProductEntity> {
        return NSFetchRequest<PsspProductEntity>(entityName: "PsspProductEntity")
    }

    @NSManaged public var image: Data?
    @NSManaged public var image_url: String?
    @NSManaged public var pack_price: Double
    @NSManaged public var stick_price: Double
    @NSManaged public var owner: InfoGraphicsEntity?
    @NSManaged public var order: Int64

}
