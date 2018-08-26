//
//  Category.swift
//  Todoey
//
//  Created by David Bowles on 20/08/2018.
//  Copyright © 2018 David Bowles. All rights reserved.
//

import Foundation
import RealmSwift

class Category:Object {
    
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
