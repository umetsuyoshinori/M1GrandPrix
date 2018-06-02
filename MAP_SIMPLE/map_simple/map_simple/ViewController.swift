//
//  ViewController.swift
//  map_simple
//
//  Created by yoshiyuki oshige on 2016/09/28.
//  Copyright © 2016年 yoshiyuki oshige. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController {
    
    // マップビュー
    @IBOutlet weak var myMap: MKMapView!
    // ツールバー
    @IBOutlet weak var toolBar: UIToolbar!
    // ツールバーのTintColorの初期値
    var defaultColor:UIColor!
    
    // 横浜みなとみらいの領域を表示する
    @IBAction func gotoSpot(_ sender: Any) {
        // 緯度と経度
        let ido = 35.454954
        let keido = 139.6313859
        // 中央に表示する座標
        let center = CLLocationCoordinate2D(latitude: ido, longitude: keido)
        // スパン
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        // 表示する領域
        let theRegion = MKCoordinateRegion(center: center, span: span)
        // 領域の地図を表示する
        myMap.setRegion(theRegion, animated: true)
    }
    
    // 地図のタイプを切り替える
    @IBAction func changedMapType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 :
            // 地図
            myMap.mapType = .standard
            // 俯角（見下ろす角度）
            myMap.camera.pitch = 0.0
            // ツールバーを標準に戻す
            toolBar.tintColor = defaultColor
            toolBar.alpha = 1.0
        case 1 :
            // 衛星写真
            myMap.mapType = .satellite
            // ツールバーを白色の半透明にする
            toolBar.tintColor = UIColor.white
            toolBar.alpha = 0.8
        case 2 :
            // 写真＋地図（ハイブリッド）
            myMap.mapType = .hybrid
            // ツールバーを白色の半透明にする
            toolBar.tintColor = UIColor.white
            toolBar.alpha = 0.8
        case 3:
            // 地図
            myMap.mapType = .standard
            // ツールバーを標準に戻す
            toolBar.tintColor = defaultColor
            toolBar.alpha = 1.0
            // 3Dビュー
            myMap.camera.pitch = 70 // 俯角（見下ろす角度）
            myMap.camera.altitude = 700 // 標高
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ツールバーの初期カラー
        defaultColor = toolBar.tintColor
        // スケールを表示する
        myMap.showsScale = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

