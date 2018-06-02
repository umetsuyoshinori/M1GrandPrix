//
//  ViewController.swift
//  map_tracking
//
//  Created by yoshiyuki oshige on 2016/09/28.
//  Copyright © 2016年 yoshiyuki oshige. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    // 地図
    @IBOutlet weak var myMap: MKMapView!
    // トラッキングボタン
    @IBOutlet weak var trackingButton: UIBarButtonItem!
    
    // ロケーションマネージャを作る
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // アプリ利用中の位置情報の利用許可を得る
        locationManager.requestWhenInUseAuthorization()
        // ロケーションマネージャのデリゲートになる
        locationManager.delegate = self
        // myMapのデリゲートになる
        myMap.delegate = self
        // スケールを表示する
        myMap.showsScale = true
    }
    
    // トラッキングモードを切り替える
    @IBAction func tapTrackingButton(_ sender: UIBarButtonItem) {
        switch myMap.userTrackingMode {
        case .none:
            // noneからfollowへ
            myMap.setUserTrackingMode(.follow, animated: true)
            // トラッキングボタンを変更する
            trackingButton.image = UIImage(named: "trackingFollow")
        case .follow:
            // followからfollowWithHeadingへ
            myMap.setUserTrackingMode(.followWithHeading, animated: true)
            // トラッキングボタンを変更する
            trackingButton.image = UIImage(named: "trackingHeading")
        case .followWithHeading:
            // followWithHeadingからnoneへ
            myMap.setUserTrackingMode(.none, animated: true)
            // トラッキングボタンを変更する
            trackingButton.image = UIImage(named: "trackingNone")
        }
    }
    
    // トラッキングが自動解除された
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        // トラッキングボタンを変更する
        trackingButton.image = UIImage(named: "trackingNone")
    }
    
    
    // 位置情報利用許可のステータスが変わった
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse :
            // ロケーションの更新を開始する
            locationManager.startUpdatingLocation()
            // トラッキングボタンを有効にする
            trackingButton.isEnabled = true
        default:
            // ロケーションの更新を停止する
            locationManager.stopUpdatingLocation()
            // トラッキングモードをnoneにする
            myMap.setUserTrackingMode(.none, animated: true)
            //トラッキングボタンを変更する
            trackingButton.image = UIImage(named: "trackingNone")
            // トラッキングボタンを無効にする
            trackingButton.isEnabled = false
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
