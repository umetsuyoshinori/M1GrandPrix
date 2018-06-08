//
//  RealmLocationObject.swift
//  GPSLogger
//
//  Created by 梅津吉雅 on 2018/06/04.
//  Copyright © 2018年 Kosuke Ogawa. All rights reserved.
//


import RealmSwift

class Location: Object {
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var createdAt = Date(timeIntervalSince1970: 1)
    @objc dynamic var song: String = "String"
}
