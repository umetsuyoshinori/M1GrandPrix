//
//  Item.swift
//  RealmSample
//
//  Created by n00877 on 2017/01/17.
//  Copyright © 2017年 Sample. All rights reserved.
//

import RealmSwift

//Onjectクラスを継承した，　Itemクラスを定義
class Item: Object{
    // 品名：動的に中身が変化するString型の変数nameを定義し，nilを代入
    @objc dynamic var name: String? = nil
    // 記入者：動的に中身が変化するString型の変数personを定義し，nilを代入
    //@objc dynamic var person: String? = nil
    // 金額：動的に中身が変化する変数priceを定義し，0を代入
    @objc dynamic var price = 0
    // 登録日時：動的に中身が変化する変数createdを定義し，現在日時を代入
    @objc dynamic var created = Date()
}
