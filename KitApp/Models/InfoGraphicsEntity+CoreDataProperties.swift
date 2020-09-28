//
//  InfoGraphicsEntity+CoreDataProperties.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/12/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//
//

import Foundation
import CoreData


extension InfoGraphicsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InfoGraphicsEntity> {
        return NSFetchRequest<InfoGraphicsEntity>(entityName: "InfoGraphicsEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var video: Data?
    @NSManaged public var video_url: String?
    @NSManaged public var infoimages: NSSet?
    @NSManaged public var psspItems: NSSet?

}

// MARK: Generated accessors for infoimages
extension InfoGraphicsEntity {

    @objc(addInfoimagesObject:)
    @NSManaged public func addToInfoimages(_ value: InfoImageEntity)

    @objc(removeInfoimagesObject:)
    @NSManaged public func removeFromInfoimages(_ value: InfoImageEntity)

    @objc(addInfoimages:)
    @NSManaged public func addToInfoimages(_ values: NSSet)

    @objc(removeInfoimages:)
    @NSManaged public func removeFromInfoimages(_ values: NSSet)

}
