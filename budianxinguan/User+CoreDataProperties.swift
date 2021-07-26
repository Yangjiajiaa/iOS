//
//  User+CoreDataProperties.swift
//  budianxinguan
//
//  Created by yjj on 2020/12/21.
//  Copyright © 2020 budianxinguan. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var levelModel: Int16
    @NSManaged public var name: String?
    @NSManaged public var times: String?

}
