//
//  PopupContentEntity+CoreDataProperties.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/17/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//
//

import Foundation
import CoreData


extension PopupContentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PopupContentEntity> {
        return NSFetchRequest<PopupContentEntity>(entityName: "PopupContentEntity")
    }

    @NSManaged public var desc: String?
    @NSManaged public var image: Data?
    @NSManaged public var owner: InfoImageEntity?

}
