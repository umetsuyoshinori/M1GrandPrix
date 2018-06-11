//
//  LocationService.swift
//  LocationStarterKit
//
//  Created by Takamitsu Mizutori on 2016/08/12.
//  Copyright © 2016年 Goldrush Computing Inc. All rights reserved.
//このページをチェック
//https://medium.com/location-tracking-tech/%E4%BD%8D%E7%BD%AE%E6%83%85%E5%A0%B1%E3%82%92%E6%AD%A3%E7%A2%BA%E3%81%AB%E3%83%88%E3%83%A9%E3%83%83%E3%82%AD%E3%83%B3%E3%82%B0%E3%81%99%E3%82%8B%E6%8A%80%E8%A1%93-in-ios-%E7%AC%AC%EF%BC%93%E5%9B%9E-%E3%83%90%E3%83%83%E3%82%AF%E3%82%B0%E3%83%A9%E3%83%B3%E3%83%89%E3%81%AE%E3%81%A7%E3%83%88%E3%83%A9%E3%83%83%E3%82%AD%E3%83%B3%E3%82%B0-%E7%B2%BE%E5%BA%A6-%E3%83%90%E3%83%83%E3%83%86%E3%83%AA%E3%83%BC%E6%B6%88%E8%B2%BB-a49c3cdb4a5a

import UIKit
import CoreLocation

public class LocationService: NSObject, CLLocationManagerDelegate{
    
    public static var sharedInstance = LocationService()
    var locationManager: CLLocationManager
    var locationDataArray: [CLLocation]
    //精度と鮮度のフィルタは常時ON
    var useFilter: Bool = true
    //画面がマーカーをデフォで追いかける
    var useTracking: Bool = true
    
    
    
    override init() {
        locationManager = CLLocationManager()
        locationDataArray = [CLLocation]()
        
        super.init()
        //デリゲートを自分に設定
        locationManager.delegate = self
        
        //位置情報の精度は最高
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //メートルいどうした時に
        //locationManager.distanceFilter = 1
        //アプリ使用中だけ位置情報を利用する許可を得る
        locationManager.requestAlwaysAuthorization()
        //バックグラウンドで位置情報を利用
        locationManager.allowsBackgroundLocationUpdates = true
        ////ポーズ中のトラッキング停止なし
        locationManager.pausesLocationUpdatesAutomatically = false
        
        //位置情報の利用開始
        locationManager.startUpdatingLocation()
        
        // ジオフェンスのモニタリング開始：このファンクションは適宜ボタンアクションなどから呼ぶ様にする。
        //self.startGeofenceMonitering()

    }
    
    //位置情報の利用を開始
    func startUpdatingLocation(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }else{
            //tell view controllers to show an alert
            showTurnOnLocationServiceAlert()
        }
    }
    
    //一回だけ位置情報を取得
    func request(){
        locationManager.requestLocation()
        print("once")
    }
    
    
    //MARK: CLLocationManagerDelegate protocol methods
    //GPSから新しい位置情報を取得"した"時に発動
    public func locationManager(_ manager: CLLocationManager,
                                  didUpdateLocations locations: [CLLocation]){
        // 最新の位置情報がnilでないとき，フィルタを用いる
        if let newLocation = locations.last{
            //コンソールに位置情報を表示
            print("(\(newLocation.coordinate.latitude), \(newLocation.coordinate.latitude))")
            var locationAdded: Bool
            //useFilterがオンになっている時
            if useFilter{//精度が妥当で，鮮度が良い位置情報のみ配列にいれる
                locationAdded = filterAndAddLocation(newLocation)
            }else{//falseのとき
                //精度や鮮度をきにせずに配列にいれる
                locationDataArray.append(newLocation)
                //精度の保証はできませんとプリント
                print("信頼度は保証できません")
                //位置情報を配列に追加したフラグを立てる
                locationAdded = true
            }
            
            //位置情報を配列に追加したフラグが立っている時
            if locationAdded{
                //位置情報の更新を各種サービスに通知
                notifiyDidUpdateLocation(newLocation: newLocation)
            }
            
        }
    }
    
    
    
    //位置情報を選別し，配列に追加する
    func filterAndAddLocation(_ location: CLLocation) -> Bool{
        //入力した位置情報の取得時刻が10秒以上前のとき，注意をプリントし，データを破棄
        let age = -location.timestamp.timeIntervalSinceNow
        if age > 10{
            print("Locaiton is old.")
            return false
        }
        //入力した位置情報の精度が0%以下のとき，注意をプリントし，データを破棄
        if location.horizontalAccuracy < 0{
            print("Latitidue and longitude values are invalid.")
            return false
        }
        //入力した位置情報の精度が100%以上のとき，注意をプリントし，データを破棄
        if location.horizontalAccuracy > 100{
            print("Accuracy is too low.")
            return false
        }
        //入力した位置情報の精度が0-100%で10秒以内のものであるとき，プリント
        print("Location quality is good enough.")
        //位置情報を配列に追加
        locationDataArray.append(location)
        
        //位置情報を配列に追加したフラグを立てる
        return true
        
    }
    
    
    
    
    public func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error){
        if (error as NSError).domain == kCLErrorDomain && (error as NSError).code == CLError.Code.denied.rawValue{
            //User denied your app access to location information.
            showTurnOnLocationServiceAlert()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager,
                                  didChangeAuthorization status: CLAuthorizationStatus){
        if status == .authorizedWhenInUse{
            //You can resume logging by calling startUpdatingLocation here
        }
    }
    
    //位置情報の利用に関するアラートを出すよう，viewControllerに通知
    func showTurnOnLocationServiceAlert(){
        NotificationCenter.default.post(name: Notification.Name(rawValue:"showTurnOnLocationServiceAlert"), object: nil)
    }    
    
    //位置情報の更新を通知
    func notifiyDidUpdateLocation(newLocation:CLLocation){
        NotificationCenter.default.post(name: Notification.Name(rawValue:"didUpdateLocation"), object: nil, userInfo: ["location" : newLocation])        
    }
}

