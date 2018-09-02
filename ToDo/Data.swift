//
//  Data.swift
//  ToDo
//
//  Created by ChanKenneth King Yan on 2018/9/1.
//  Copyright © 2018年 CQLOGIC. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc var age: Int = 0
}
