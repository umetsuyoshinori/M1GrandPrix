//
//  Item.swift
//  RealmSample
//
//  Created by n00877 on 2017/01/17.
//  Copyright © 2017年 Sample. All rights reserved.
//

import RealmSwift

class Item: Object{
    // 品名
    @objc dynamic var name: String? = nil
    // 金額
    @objc dynamic var price = 0
    // 登録日時
    @objc dynamic var created = Date()
}

class SongInfo: Object{
    // id
    @objc dynamic var id: String? = nil
    // 曲名
    @objc dynamic var price: String? = nil
    // 収録アルバム
    @objc dynamic var albam: String? = nil
    //アーティスト
    @objc dynamic var artist: String? = nil
    //ジャケット写真
//    @objc dynamic var artworkId: String? = nil
}
