//
//  InfoImageEntity+CoreDataProperties.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/17/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//
//

import Foundation
import CoreData


extension InfoImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InfoImageEntity> {
        return NSFetchRequest<InfoImageEntity>(entityName: "InfoImageEntity")
    }

    @NSManaged public var caption: String?
    @NSManaged public var index: Int64
    @NSManaged public var image: Data?
    @NSManaged public var image_url: String?
    @NSManaged public var owner: InfoGraphicsEntity?
    @NSManaged public var popupcontent: PopupContentEntity?

}
