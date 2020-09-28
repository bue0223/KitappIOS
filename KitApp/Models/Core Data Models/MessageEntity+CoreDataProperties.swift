//
//  MessageEntity+CoreDataProperties.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/9/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//
//

import Foundation
import CoreData


extension MessageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageEntity> {
        return NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var content: String?
    @NSManaged public var page: String?
    @NSManaged public var screen_title: String?

}
