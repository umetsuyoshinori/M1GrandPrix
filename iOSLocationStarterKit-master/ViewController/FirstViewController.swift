//
//  FirstViewController.swift
//  LocationStarterKit
//
//  Created by 梅津吉雅 on 2018/06/11.
//  Copyright © 2018年 Goldrush Computing Inc. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    var sharedInstance:LocationService = LocationService.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        //位置情報取得の許可を監視し，適宜アラートを発動
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.showTurnOnLocationServiceAlert(_:)), name: Notification.Name(rawValue:"showTurnOnLocationServiceAlert"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
