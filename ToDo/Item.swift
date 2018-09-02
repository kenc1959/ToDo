//
//  Item.swift
//  ToDo
//
//  Created by ChanKenneth King Yan on 2018/9/2.
//  Copyright © 2018年 CQLOGIC. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "Items")
}
