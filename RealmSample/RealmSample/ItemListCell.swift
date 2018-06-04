//
//  ItemListCell.swift
//  RealmSample
//
//  Created by n00877 on 2017/01/17.
//  Copyright © 2017年 Sample. All rights reserved.
//

import UIKit

class ItemListCell: UITableViewCell {
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

class SongListCell: UITableViewCell {
    
    @IBOutlet weak var Song: UILabel!
    @IBOutlet weak var Albam: UILabel!
    @IBOutlet weak var Artist: UILabel!
    @IBOutlet weak var ArtworkId: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

