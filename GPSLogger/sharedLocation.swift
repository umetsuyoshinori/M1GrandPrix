import MapKit
import RealmSwift
import UIKit
import Foundation

//ただのクラス
class Data {
    var title: String
    var contents: String
    
    init(title: String, contents: String) {
        self.title = title
        self.contents = contents
    }
    
}

/*あるクラスと、その唯一のインスタンスを"予め作成"し、"共有"するためのモデル*/
//シングルトン用クラス
class sharedLocation:NSObject,CLLocationManagerDelegate{
    // 自動的に遅延初期化される(初回アクセスのタイミングで"インスタンス"生成)
    static let Manager: sharedLocation = sharedLocation()
    
    var data = Data(title: "", contents: "")
    
    let locationManager: CLLocationManager
    var locations: Results<Location>!
    var token: NotificationToken!
    var isUpdating = false
    
    // 外部からのインスタンス生成をコンパイルレベルで禁止(親クラスにinitがあるとき，overrideが必要)
    override init() {
        
        //CLLocationManagerクラスのインスタンスを作成
        locationManager = CLLocationManager()
        
        //親クラスのinit()を先に出せと言われる。
        super.init()
        
        //デリゲートを自分に設定
        locationManager.delegate = self

        // アプリ利用中の位置情報の利用許可を得る
        locationManager.requestAlwaysAuthorization()
        //求める精度は最高
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //メートル離れるごとに位置情報を取得
        locationManager.distanceFilter = 5
        // 前日までのロケーションオブジェクトを削除
        deleteOldLocations()
        
        // 蓄積したロケーション情報を読み込み
        self.locations = self.loadStoredLocations()

//        // ピンを落とす
//        for location in self.locations {
//            self.dropPin(mapView:MKMapView, at: location)
//        }
    }
    
    //自作関数
    func getLongitude() -> CLLocationDegrees{
        let longitude = locationManager.location?.coordinate.longitude
        return longitude!
    }
    
    // [関数]バックグラウンドスレッドで，昨日までのオブジェクトを削除
    func deleteOldLocations() {
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
    
    // [関数]realmに保存してあるロケーション情報をテーブルビューに読み込み
    func loadStoredLocations() -> Results<Location> {
        // レルム使う
        let realm = try! Realm()

        // 最近のロケーションオブジェクトを読み込む
        return realm.objects(Location.self).sorted(byKeyPath: "createdAt", ascending: false)
    }
    
    // [関数]ロケーションの更新を開始/停止
    func toggleLocationUpdate(startButton:UIButton, tableView: UITableView) {
        let realm = try! Realm()
        if self.isUpdating {
            // 停止
            self.isUpdating = false
            self.locationManager.stopUpdatingLocation()
            startButton.setTitle("Start", for: UIControlState())
            
            // 以前蓄積した通知を消去
            if let token = self.token {
                token.invalidate()
            }
        } else {
            // 開始
            self.isUpdating = true
            self.locationManager.startUpdatingLocation()
            startButton.setTitle("Stop", for: UIControlState())
            
            // 変更に対し，ノーティフィケーションハンドラを追加
            self.token = realm.observe {
                [weak self] notification, realm in
                tableView.reloadData()
            }
        }
    }
    
    // [関数]オブジェクトをrealmに追加
    func addCurrentLocation(_ rowLocation: CLLocation) {
        let location = makeLocation(rawLocation: rowLocation)
        
        // レルム使う
        let realm = try! Realm()
        
        //トランザクションをレルム内部に格納
        try! realm.write {
            realm.add(location)
        }
    }
    
    // [関数]レルムから全てのロケーションオブジェクトを消去
    func deleteAllLocations() {
        // レルム使う
        let realm = try! Realm()
        
        // レルムから全てのオブジェクトを削除
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    // [関数]CLLocationからロケーションオブジェクトを作成
    func makeLocation(rawLocation: CLLocation) -> Location {
        let location = Location()
        location.latitude = rawLocation.coordinate.latitude
        location.longitude = rawLocation.coordinate.longitude
        location.createdAt = Date()
        location.song = "song"
        return location
    }
    
    // [関数]マップにピンを落とす
    func dropPin(mapView:MKMapView,at location: Location) {
        //初期位置(0,0)でないとき
        if location.latitude != 0 && location.longitude != 0 {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
            annotation.title = "\(location.latitude),\(location.longitude)"
            annotation.subtitle = location.createdAt.description + location.song
            mapView.addAnnotation(annotation)
        }
    }
    
    // [関数]マップから全てピンを消去
    func removeAllAnnotations(mapView:MKMapView) {
        let annotations = mapView.annotations.filter {
            $0 !== mapView.userLocation
        }
        mapView.removeAnnotations(annotations)
    }
    
    //    // MARK: - CLLocationManagerのデリゲート
        //位置情報の利用申請が完了した直後に発動
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus, mapView: MKMapView) {
            // 位置情報の利用許可が得られなかった場合場合，許可を得る
            if status == CLAuthorizationStatus.notDetermined {
                locationManager.requestAlwaysAuthorization()
            }// 位置情報の利用許可が得られた場合，マップを形成する
            else if status == CLAuthorizationStatus.authorizedAlways {
                //縮尺
                let span = MKCoordinateSpanMake(0.003, 0.003)
                //中心座標と縮尺から表示領域
                let region = MKCoordinateRegionMake(mapView.userLocation.coordinate,span)
                //マップのオブジェクトに表示領域をセット
                mapView.setRegion(region, animated:true)
                //マップのオブジェクトに現在位置のトラッキング方法を指定
                mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
            }
        }
    
    //位置が変更になった直後に発動
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation],mapView:MKMapView) {
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
        dropPin(mapView: mapView, at: location)
    }

}
