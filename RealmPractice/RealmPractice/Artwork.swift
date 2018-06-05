//
//  Song.swift
//  RealmPractice
//
//  Created by 梅津吉雅 on 2018/06/04.
//  Copyright © 2018年 梅津吉雅. All rights reserved.
//

import RealmSwift

/**RealmSwiftに含まれるObject型を継承したクラスを作ります。
 プロパティはdynamic varで宣言します。*/
class Artwork: Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var imageData: NSData? = nil
}
