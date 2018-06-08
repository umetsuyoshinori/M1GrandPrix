//
//  ViewController.swift
//  GPSLogger
//
//  Created by koogawa on 2015/08/01.
//  Copyright (c) 2015 Kosuke Ogawa. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift



class secondViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // CLLocationManagerクラスのインスタンスを作成
    var locationManager = CLLocationManager()
    
    var locations: Results<Location>!
    var token: NotificationToken!
    var isUpdating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableViewのデリゲート、データソースになる
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // アプリ利用中の位置情報の利用許可を得る
        locationManager.requestAlwaysAuthorization()
        //ロケーションマネージャのデリゲートになる
        self.locationManager.delegate = self
        //求める精度は最高
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //メートル離れた時
        self.locationManager.distanceFilter = 5
        
        // 前日までのロケーションオブジェクトを削除
        self.deleteOldLocations()
        
        // 蓄積したロケーション情報を読み込み
        self.locations = self.loadStoredLocations()
        
        // ピンを落とす
        for location in self.locations {
            self.dropPin(at: location)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Private methods
    
    //（スタートボタンをタップ）
    @IBAction func startButtonDidTap(_ sender: AnyObject) {
        self.toggleLocationUpdate()
    }
    
    //（クリアボタンをタップ）
    @IBAction func clearButtonDidTap(_ sender: AnyObject) {
        self.deleteAllLocations()
        self.locations = self.loadStoredLocations()
        self.removeAllAnnotations()
        self.tableView.reloadData()
    }
    
    // realmに保存してあるロケーション情報をテーブルビューに読み込み
    fileprivate func loadStoredLocations() -> Results<Location> {
        // レルム使う
        let realm = try! Realm()
        
        // 最近のロケーションオブジェクトを読み込む
        return realm.objects(Location.self).sorted(byKeyPath: "createdAt", ascending: false)
    }
    
    // ロケーションの更新を開始/停止
    fileprivate func toggleLocationUpdate() {
        let realm = try! Realm()
        if self.isUpdating {
            // 停止
            self.isUpdating = false
            self.locationManager.stopUpdatingLocation()
            self.startButton.setTitle("Start", for: UIControlState())
            
            // 以前蓄積した通知を消去
            if let token = self.token {
                token.invalidate()
            }
        } else {
            // 開始
            self.isUpdating = true
            self.locationManager.startUpdatingLocation()
            self.startButton.setTitle("Stop", for: UIControlState())
            
            // 変更に対し，ノーティフィケーションハンドラを追加
            self.token = realm.observe {
                [weak self] notification, realm in
                self?.tableView.reloadData()
            }
        }
    }
    
    // オブジェクトをrealmに追加
    fileprivate func addCurrentLocation(_ rowLocation: CLLocation) {
        let location = makeLocation(rawLocation: rowLocation)
        
        // レルム使う
        let realm = try! Realm()
        
        //トランザクションをレルム内部に格納
        try! realm.write {
            realm.add(location)
        }
    }
    
    // バックグラウンドスレッドで，昨日までのオブジェクトを削除
    fileprivate func deleteOldLocations() {
        DispatchQueue.global().async {
            // レルム使う
            let realm = try! Realm()
            
            // レルム内の古いロケーションオブジェクト
            let oldLocations = realm.objects(Location.self).filter(NSPredicate(format:"createdAt < %@", NSDate().addingTimeInterval(-86400)))
            
            // オブジェクトをトランザクションとともに消去
            try! realm.write {
                realm.delete(oldLocations)
            }
        }
    }
    
    // レルムから全てのロケーションオブジェクトを消去
    fileprivate func deleteAllLocations() {
        // レルム使う
        let realm = try! Realm()
        
        // レルムから全てのオブジェクトを削除
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    // CLLocationからロケーションオブジェクトを作成
    fileprivate func makeLocation(rawLocation: CLLocation) -> Location {
        let location = Location()
        location.latitude = rawLocation.coordinate.latitude
        location.longitude = rawLocation.coordinate.longitude
        location.createdAt = Date()
        location.song = "song"
        return location
    }
    
    // マップにピンを落とす
    fileprivate func dropPin(at location: Location) {
        //初期位置(0,0)でないとき
        if location.latitude != 0 && location.longitude != 0 {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
            annotation.title = "\(location.latitude),\(location.longitude)"
            annotation.subtitle = location.createdAt.description + location.song
            self.mapView.addAnnotation(annotation)
        }
    }
    
    // マップから全てピンを消去
    fileprivate func removeAllAnnotations() {
        let annotations = self.mapView.annotations.filter {
            $0 !== self.mapView.userLocation
        }
        self.mapView.removeAnnotations(annotations)
    }
    
    // MARK: - CLLocationManagerのデリゲート
    //位置情報の利用申請が完了した直後に発動
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 位置情報の利用許可が得られなかった場合場合，許可を得る
        if status == CLAuthorizationStatus.notDetermined {
            locationManager.requestAlwaysAuthorization()
        }// 位置情報の利用許可が得られた場合，マップを形成する
        else if status == CLAuthorizationStatus.authorizedAlways {
            //縮尺
            let span = MKCoordinateSpanMake(0.003, 0.003)
            //中心座標と縮尺から表示領域
            let region = MKCoordinateRegionMake(self.mapView.userLocation.coordinate,span)
            //マップのオブジェクトに表示領域をセット
            self.mapView.setRegion(region, animated:true)
            //マップのオブジェクトに現在位置のトラッキング方法を指定
            self.mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        }
    }
    
    //位置が変更になった直後に発動
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        //
        guard let newLocation = locations.last else {
            return
        }
        
        if !CLLocationCoordinate2DIsValid(newLocation.coordinate) {
            return
        }
        // 新しい位置情報をrealmに追加
        self.addCurrentLocation(newLocation)
        
        let location = makeLocation(rawLocation: newLocation)
        dropPin(at: location)
    }
    
    
    // MARK: - MKMapView delegate
    
    func mapView(_ mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "annotationIdentifier"
        
        var pinView = self.mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.animatesDrop = true
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        let location = self.locations[indexPath.row]
        cell.textLabel?.text = "\(location.latitude),\(location.longitude)"
        cell.detailTextLabel?.text = location.createdAt.description
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

