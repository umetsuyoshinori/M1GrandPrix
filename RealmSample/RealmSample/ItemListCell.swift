//
//  ItemListCell.swift
//  RealmSample
//
//  Created by n00877 on 2017/01/17.
//  Copyright © 2017年 Sample. All rights reserved.
//

import UIKit

//UITableViewCellクラスを継承した，ItemListCellクラスを定義
class ItemListCell: UITableViewCell {
    
    //日付：変数lblDateをstorybord上のUILabelとOutlet接続
    @IBOutlet weak var lblDate: UILabel!
    //品名：変数lblNameをstorybord上のUILabelとOutlet接続
    @IBOutlet weak var lblName: UILabel!
    //値段：変数lblPriceをstorybord上のUILabelとOutlet接続
    @IBOutlet weak var lblPrice: UILabel!
    
    //@IBOutlet weak var lblPerson: UILabel!
    
    //親クラスのlayoutSubviewsメソッドを上書き
    override func layoutSubviews() {
        //親クラスのlayoutSubviewsメソッドを使用
        super.layoutSubviews()
    }
    
}

