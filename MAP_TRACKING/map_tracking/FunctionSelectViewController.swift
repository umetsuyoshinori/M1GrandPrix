//
//  FunctionSelectViewController.swift
//  map_tracking
//
//  Created by 梅津吉雅 on 2018/06/03.
//  Copyright © 2018年 yoshiyuki oshige. All rights reserved.
//

import UIKit

class FunctionSelectViewController: UIViewController {
    
    @IBOutlet weak var testLabel: UILabel!
    @IBAction func testUISwitch(_ sender: UISwitch) {
        if ( sender.isOn ) {
            testLabel.text = "ON"
        } else {
            testLabel.text = "OFF"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
