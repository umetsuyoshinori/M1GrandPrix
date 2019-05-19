////
////  LocationService.swift
////  LocationStarterKit
////
////  Created by Takamitsu Mizutori on 2016/08/12.
////  Copyright © 2016年 Goldrush Computing Inc. All rights reserved.
////このページをチェック
////https://medium.com/location-tracking-tech/%E4%BD%8D%E7%BD%AE%E6%83%85%E5%A0%B1%E3%82%92%E6%AD%A3%E7%A2%BA%E3%81%AB%E3%83%88%E3%83%A9%E3%83%83%E3%82%AD%E3%83%B3%E3%82%B0%E3%81%99%E3%82%8B%E6%8A%80%E8%A1%93-in-ios-%E7%AC%AC%EF%BC%93%E5%9B%9E-%E3%83%90%E3%83%83%E3%82%AF%E3%82%B0%E3%83%A9%E3%83%B3%E3%83%89%E3%81%AE%E3%81%A7%E3%83%88%E3%83%A9%E3%83%83%E3%82%AD%E3%83%B3%E3%82%B0-%E7%B2%BE%E5%BA%A6-%E3%83%90%E3%83%83%E3%83%86%E3%83%AA%E3%83%BC%E6%B6%88%E8%B2%BB-a49c3cdb4a5a
//
//import UIKit
//import CoreLocation
//
//public class LocationService: NSObject, CLLocationManagerDelegate{
//    
//    public static var sharedInstance = LocationService()
//    let locationManager: CLLocationManager
//    var locationDataArray: [CLLocation]
//    var useFilter: Bool
//    
//    
////    override init() {
////        locationManager = CLLocationManager()
////
////        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
////        locationManager.distanceFilter = 5
////
////        locationManager.requestWhenInUseAuthorization()
////        locationManager.allowsBackgroundLocationUpdates = true
////        locationManager.pausesLocationUpdatesAutomatically = false //ポーズ中のトラッキング停止なし
////        locationDataArray = [CLLocation]()
////
////        useFilter = true//distanceフィルターを使う
////
////        super.init()
////
////        //デリゲートを自分に設定
////        locationManager.delegate = self
////
////
////    }
//    
//    
////    func startUpdatingLocation(){
////        if CLLocationManager.locationServicesEnabled(){
////            locationManager.startUpdatingLocation()
////        }else{
////            //tell view controllers to show an alert
////            showTurnOnLocationServiceAlert()
////        }
////    }
//    
//    
//    
//    
//    
//    
//    //MARK: CLLocationManagerDelegate protocol methods
////    public func locationManager(_ manager: CLLocationManager,
////                                didUpdateLocations locations: [CLLocation]){
////
////        if let newLocation = locations.last{
////            print("(\(newLocation.coordinate.latitude), \(newLocation.coordinate.latitude))")
////
////            var locationAdded: Bool
////            if useFilter{
////                locationAdded = filterAndAddLocation(newLocation)
////            }else{
////                locationDataArray.append(newLocation)
////                locationAdded = true
////            }
////
////
////            if locationAdded{
////                notifiyDidUpdateLocation(newLocation: newLocation)
////            }
////
////        }
////    }
////
////    func filterAndAddLocation(_ location: CLLocation) -> Bool{
////        let age = -location.timestamp.timeIntervalSinceNow
////
////        if age > 10{
////            print("Locaiton is old.")
////            return false
////        }
////
////        if location.horizontalAccuracy < 0{
////            print("Latitidue and longitude values are invalid.")
////            return false
////        }
////
////        if location.horizontalAccuracy > 100{
////            print("Accuracy is too low.")
////            return false
////        }
////
////        print("Location quality is good enough.")
////        locationDataArray.append(location)
////
////        return true
////
////    }
////
////
////    public func locationManager(_ manager: CLLocationManager,
////                                didFailWithError error: Error){
////        if (error as NSError).domain == kCLErrorDomain && (error as NSError).code == CLError.Code.denied.rawValue{
////            //User denied your app access to location information.
////            showTurnOnLocationServiceAlert()
////        }
////    }
////
////    public func locationManager(_ manager: CLLocationManager,
////                                didChangeAuthorization status: CLAuthorizationStatus){
////        if status == .authorizedWhenInUse{
////            //You can resume logging by calling startUpdatingLocation here
////        }
////    }
////
////    func showTurnOnLocationServiceAlert(){
////        NotificationCenter.default.post(name: Notification.Name(rawValue:"showTurnOnLocationServiceAlert"), object: nil)
////    }
////
////    func notifiyDidUpdateLocation(newLocation:CLLocation){
////        NotificationCenter.default.post(name: Notification.Name(rawValue:"didUpdateLocation"), object: nil, userInfo: ["location" : newLocation])
////    }
////}
//
