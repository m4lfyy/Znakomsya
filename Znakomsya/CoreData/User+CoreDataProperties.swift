//
//  User+CoreDataProperties.swift
//  Znakomsya
//
//  Created by Павел Панчук on 30.03.2024.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var gender: String?
    @NSManaged public var birthData: Date?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var password: String?

}

extension User : Identifiable {

}
