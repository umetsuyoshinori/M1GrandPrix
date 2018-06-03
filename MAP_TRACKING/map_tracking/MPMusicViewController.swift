//
//  MPMusicViewController.swift
//  map_tracking
//
//  Created by 梅津吉雅 on 2018/06/03.
//  Copyright © 2018年 yoshiyuki oshige. All rights reserved.
//

import UIKit

class MPMusicViewController: UIViewController {

    @IBOutlet weak var off: UILabel!
    @IBAction func ac(_ sender: UISwitch) {
        if ( sender.isOn ) {
            off.text = "ON"
        } else {
            off.text = "OFF"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
