//
//  Item.swift
//  Todoey
//
//  Created by David Bowles on 20/08/2018.
//  Copyright © 2018 David Bowles. All rights reserved.
//

import Foundation
import RealmSwift

class Item:Object  {
    @objc dynamic var title : String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var createdDate = NSDate()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
