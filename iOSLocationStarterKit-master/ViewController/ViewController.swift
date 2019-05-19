import UIKit
import MapKit
import RealmSwift
import MediaPlayer
import Foundation

class ViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var uiSwitch: UISwitch!
    var userAnnotationImage: UIImage?//アノテーション画像
    var userAnnotation: UserAnnotation?// アノテーションインスタンス
    var placeAnnotation = PlaceAnnotation()//アノテーションインスタンス
    var polyline: MKPolyline?
    var isZooming: Bool?
    var isBlockingAutoZoom: Bool?
    var didInitialZoom: Bool?//
    var nowLocation: CLLocation?
    
    //アノテーションに記載する情報
    var name: String = ""
    var album: String = ""
    var artist: String = ""
    var artwork = Data()
    var lati: String = ""
    var longi: String = ""
    var date: String = ""
    //アノテーション（ピン）の作成
    var doubleLati: Double = 0.0
    var doubleLongi: Double = 0.0
    
    //位置情報サービスを司るシングルトン
    var sharedInstance:LocationService = LocationService.sharedInstance
    
    //シングルトン呼び出し
    let player = MusicService().player



    override func viewDidLoad() {
        super.viewDidLoad()
        //精度と鮮度のフィルタは常時ON
        sharedInstance.useFilter = true
        
        //自身をmapViewのデリゲートに設定
        self.mapView.delegate = self
        //自分の位置に青丸を使う
        self.mapView.showsUserLocation = true
        //アノテーション画像に自前の赤丸を設定
        //self.userAnnotationImage = UIImage(named: "user_position_ball")!
        //初期位置のズームをした後かどうかのフラグを設定
        self.didInitialZoom = false
        
        //ロケーションのアップデートを監視し，適宜updateMapを発動
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateMap(_:)), name: Notification.Name(rawValue:"didUpdateLocation"), object: nil)
        
        //位置情報取得の許可を監視し，適宜アラートを発動
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.showTurnOnLocationServiceAlert(_:)), name: Notification.Name(rawValue:"showTurnOnLocationServiceAlert"), object: nil)
    }
    
    //この画面に入るたび,必ず一発目の処理として行う
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        //音楽履歴にピンを降らす
        self.dropLocationMusicPin()
        //今の位置に画面をもっていく
        nowLocation = sharedInstance.locationManager.location
        if nowLocation != nil{
        zoomTo(location: nowLocation!)
        self.didInitialZoom = false
        }
        if sharedInstance.useTracking == true{//スイッチONの時
            uiSwitch.setOn(true, animated: false)
        }else{//スイッチOFFの時
            uiSwitch.setOn(false, animated: false)
        }
    }
    
    
    
    
    
    //マップにピンを立てる
    func dropPin(at location: CLLocation) {
        //初期位置(0,0)でないとき
        if location.coordinate.latitude != 0 && location.coordinate.longitude != 0 {
            let annotation = placeAnnotation
            annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let lati = location.coordinate.latitude
            let longi = location.coordinate.longitude
            let date = location.timestamp.description
            annotation.title = "songname"
            annotation.subtitle = "artist"+"\n"+date+"\n"+"\(lati),\(longi)"
            self.mapView.addAnnotation(annotation)
        }
    }
    
    //realmLocationMusic内の情報をもとにピンをマップ上に立てる
    func dropLocationMusicPin(){
        let realmLocationMusic = try! Realm()
        let allDataArray = Array(realmLocationMusic.objects(LocationMusic.self))
        var annotationArray = [MKAnnotation]()
        //すべての要素でピンの作成，マップ追加
        for row in allDataArray {
            let annotation = PlaceAnnotation()
            //アノテーションに記載する情報
            name = row.name
            album = row.album
            artist = row.artist
            artwork = row.artwork
            lati = row.latitude
            longi = row.longitude
            date = row.Date
            doubleLati = atof(lati)
            doubleLongi = atof(longi)
            //アノテーションの詳細
            annotation.title = name
            annotation.subtitle = artist+"\n"+date+"\n"+"\(String(describing: lati)),\(String(describing: longi))"+"あばば"+album+"あばば"+artist
            annotation.coordinate = CLLocationCoordinate2DMake(doubleLati, doubleLongi)
            annotation.album = album
            annotation.artist = artist
            annotation.artwork = artwork
            //配列にピンを追加
            annotationArray.append(annotation)
        }
        //mapViewに配列のピンを適用
        self.mapView.addAnnotations(annotationArray)
    }
    
    //位置情報取得の許可が下りなかったら，アラートを出す
    @objc func showTurnOnLocationServiceAlert(_ notification: NSNotification){
        let alert = UIAlertController(title: "Turn on Location Service", message: "To use this app, please turn on the location service from the Settings app.", preferredStyle: .alert)
        //"setting"選択肢を作成
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        //"cancel"選択肢を作成
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        //アラートに"setting"の選択肢を追加
        alert.addAction(settingsAction)
        //アラートに"cancel"の選択肢を追加
        alert.addAction(cancelAction)
        
        //アラートを表示
        present(alert, animated: true, completion: nil)
        
    }
    
    //通知内容を元に,マップを更新する
    @objc func updateMap(_ notification: NSNotification){
        //通知に含まれるuserInfo(辞書型)がnilでなかったら
        if let userInfo = notification.userInfo{
            //マップ上の線を更新し，伸ばす．
            updatePolylines()
            //さらに，userInfoが"location"キーに対する値をもつ時
            if let newLocation = userInfo["location"] as? CLLocation{
                if sharedInstance.useTracking == true{
                    //新しい位置へズームする．
                    zoomTo(location: newLocation)
                }else{
                    //何もしない
                }
            }
        }
    }

    
    //マップ上の線を更新し，伸ばす
    func updatePolylines(){
        //平面位置(x,y)の配列作成
        var coordinateArray = [CLLocationCoordinate2D]()
        //位置情報の配列の要素(平面位置，高さ，平面精度，高さ精度，時刻)から，
        for loc in LocationService.sharedInstance.locationDataArray{
            //平面位置（x,y）のみを抽出していく
            coordinateArray.append(loc.coordinate)
        }
        //全部線消しまーす
        self.clearPolyline()
        //作った配列の要素(x,y)をなぞるような線を作りまーす
        self.polyline = MKPolyline(coordinates: coordinateArray, count: coordinateArray.count)
        //線をmapViewにプロパティとして追加
        self.mapView.add(polyline! as MKOverlay)
        
    }
    
    //マップ上の線を消す
    func clearPolyline(){
        //線があるとき
        if self.polyline != nil{
            //線を消す
            self.mapView.remove(self.polyline!)
            //籍は残したいので，nilを入れとく
            self.polyline = nil
        }
    }
    
    //ある位置にズームする
    func zoomTo(location: CLLocation){
        //（初回）イニシャルズーム済みフラグがfalseなら
        if self.didInitialZoom == false{
            //ユーザ位置にズームし，イニシャルズーム済みフラグをtrueにする
            let coordinate = location.coordinate
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 300, 300)
            self.mapView.setRegion(region, animated: false)
            //この間にregionWillChangeAnimatedが呼び出される
            self.didInitialZoom = true
        }
        //（2回目以降）オートズームさせないフラグがfalseなら
        if self.isBlockingAutoZoom == false{
            //ズーム中フラグを立てる
            self.isZooming = true
            //マップの中心を現在地に合わせる
            self.mapView.setCenter(location.coordinate, animated: true)
        }
    }
    
    //MKMapViewのデリゲート
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polylineRenderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            polylineRenderer.strokeColor = UIColor(rgb:0x1b60fe)
            polylineRenderer.alpha = 0.5
            polylineRenderer.lineWidth = 5.0
        
            return polylineRenderer
//        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "annotationIdentifier"
        
        var pinView = self.mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.animatesDrop = true
            
            // pinのクラス名を取得（今回の場合は「CustomAnnotation」になります）
            switch NSStringFromClass(type(of: annotation)).components(separatedBy:".").last! as String {
            case "PlaceAnnotation":
                // ( annotation as! PlaceAnnotation )をしないと
                // CustomAnnotationクラスで定義した変数が取れないので注意！
                if ( annotation as! PlaceAnnotation ).artist != nil {
                }
                
            default: break
            }

        }
        else {
            pinView?.annotation = annotation
        }
        
        //THIS IS THE GOOD BIT
        let subtitleView = UILabel()
        subtitleView.font = subtitleView.font.withSize(12)
        subtitleView.numberOfLines = 3
        subtitleView.text = annotation.subtitle??.components(separatedBy:"あばば")[0]
        pinView!.detailCalloutAccessoryView = subtitleView
        
        //左にアルバムのジャケットを表示する
        let button = UIButton()
        button.frame = CGRect(x:0,y:0,width:100,height:100)

        var AW: UIImage
        //annotationのartworkを保持できていない時
        if annotation.artwork == nil{
            // realmからジャケ写画像を検索
            let realm = try! Realm()
            let name = annotation.title
            let album = annotation.subtitle??.components(separatedBy:"あばば")[1]
            let artist = annotation.subtitle??.components(separatedBy:"あばば")[2]
            
            // 曲名とアルバム名，アーティスト名でrealm内のオブジェクトを絞り込み（配列で返る）
            //let predicate = NSPredicate(format: )
            let results = realm.objects(LocationMusic.self).filter("name = %@", name)
            var resultss = results.filter("album = %@", album)
            var resultsss = resultss.filter("artist = %@", artist)
            
            // ためしに検索結果のIDと名前を表示
            for one in results {
                print("\(one.name): \(one.album): \(one.artist)")
            }
            //検索結果の一番上のを画像に変換
            let result1stImage = UIImage(data: (results.first?.artwork)!)
            //その画像をジャケ写として使う
            AW = result1stImage!
            
        }else{//保持できている時
            //保持している画像データを画像に変換し，ジャケ写にする
            AW = UIImage(data: annotation.artwork!)!
        }
        
        button.setImage(AW, for: [])
        pinView?.leftCalloutAccessoryView = button
        
        //右ボタンをアノテーションビューに追加する。（きく）
        let button2 = UIButton()
        button2.frame = CGRect(x:0,y:0,width:40,height:40)
        button2.setTitle("きく", for:[])
        //ランダム色の画像を生成
        let color = UIColor.random
        button2.backgroundColor = color
        button2.setTitleColor(UIColor.white, for:[])
        pinView?.rightCalloutAccessoryView = button2
        
        
        return pinView
    }
    
    //吹き出しアクササリー押下時の呼び出しメソッド
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if(control == view.leftCalloutAccessoryView) {
            // ① UIAlertControllerクラスのインスタンスを生成
            // タイトル, メッセージ, Alertのスタイルを指定する
            // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
            let alert: UIAlertController = UIAlertController(title: (view.annotation?.title)!, message: "コメント：なし", preferredStyle:  UIAlertControllerStyle.alert)
            
            // ② Actionの設定
            // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
            // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
            // 削除ボタン
            let deleatAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertActionStyle.destructive, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("削除する")
            })
            // コメントボタン
            let commentAction: UIAlertAction = UIAlertAction(title: "コメントをのこす", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("コメントを残すよ")
            })
            // キャンセルボタン
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("キャンセルだよ")
            })
            // ③ UIAlertControllerにActionを追加
            alert.addAction(cancelAction)
            alert.addAction(commentAction)
            alert.addAction(deleatAction)
            
            // ④ Alertを表示
            present(alert, animated: true, completion: nil)
        } else {
            
            //右のボタンが押された場合はきく
            let song = view.annotation?.title
            let album = view.annotation?.subtitle??.components(separatedBy:"あばば")[1]
            let artist = view.annotation?.subtitle??.components(separatedBy:"あばば")[2]
                
            let query = Query.tripleFilter(song: song!!, albam: album!, artist: artist!)
            
            if query != nil{
                //一旦，realm内のSongクラスオブジェクトを全部削除
                let realm = try! Realm()
                let Songs = realm.objects(Song.self)
                try! realm.write {
                    // Realmに保存されているSong型のオブジェクトを全て削除
                    realm.delete(Songs)
                }
                
                player.setQueue(with: query!)
                player.play()
                self.performSegue(withIdentifier: "fromMapToPlay", sender: nil)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {//2回目以降
        //2回目以降のZoomToの分岐を誘発
        self.isBlockingAutoZoom = false;
    }
    
    //トラッキング機能のオンオフを司るスイッチ
    @IBAction func trackingSwitchAction(_ sender: UISwitch) {
        if sender.isOn{//スイッチONの時
            sharedInstance.useTracking = true
        }else{//スイッチOFFの時
            sharedInstance.useTracking = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

