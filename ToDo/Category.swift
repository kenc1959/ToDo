//
//  Category.swift
//  ToDo
//
//  Created by ChanKenneth King Yan on 2018/9/2.
//  Copyright © 2018年 CQLOGIC. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
