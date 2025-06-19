//
//  DogEntity+CoreDataClass.swift
//  KDogsApp
//
//  Created by Pablo Ramirez on 18/06/25.
//

import Foundation
import CoreData

@objc(DogEntity)
public class DogEntity: NSManagedObject { }

extension DogEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DogEntity> {
        return NSFetchRequest<DogEntity>(entityName: "DogEntity")
    }

    @NSManaged public var dogName: String
    @NSManaged public var descrip: String
    @NSManaged public var age: Int32
    @NSManaged public var image: String
}
