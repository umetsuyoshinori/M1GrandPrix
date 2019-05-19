import CoreLocation
import UserNotifications
import NotificationCenter

extension CLLocation {
    
    //そこに自作ジオフェンスを作る関数
    func makeGeoFence(){
//        /*通知の中身*/
//        let content = UNMutableNotificationContent()
//        //タイトル
//        content.title = "曲名"
//        content.subtitle = "アーティスト"
//        content.body = "場所と時間，コメント"
//        content.sound = UNNotificationSound.default()//音はデフォで
//
//        /*トリガ*/
//        let target: CLLocationCoordinate2D = self.coordinate  // 中心地は現在地
//        let radius: CLLocationDistance = 50.0;  // 半径何メートルで通知するか
//        //上記二つからトリガ領域を作成
//        let region: CLCircularRegion = CLCircularRegion(center: target, radius:radius, identifier:"identifier")
//        //入るときだけ通知させる（出たとき通知消したい）
//        region.notifyOnEntry = true
//        region.notifyOnExit = false
//        //トリガーを作成(繰り返し通知する)
//        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
//
//        /*リクエストの作成*/
//        let request = UNNotificationRequest(identifier: "geoFence", content: content, trigger: trigger)
//        print("ジオフェンス展開！\(self.coordinate.latitude):\(self.coordinate.longitude)")
//        /*通知センターのインスタンスに，リクエストをセット*/
//        let center = UNUserNotificationCenter.current()
//        center.add(request) { (error : Error?) in
//            if error != nil {//エラーのときは，コンソールに記述
//                print("ごめん，無理だった")
//            }
//        }
        
        let seconds = 0.1
        
        // ------------------------------------
        // 通知の発行: タイマーを指定して発行
        // ------------------------------------
        
        // content
        let content = UNMutableNotificationContent()
        content.title = "title"
        content.subtitle = "subtitle.\(seconds) seconds elapsed!"
        content.body = "body. \(seconds) seconds."
        content.sound = UNNotificationSound.default()
        
        // trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(seconds),
                                                        repeats: false)
        
        // request includes content & trigger
        let request = UNNotificationRequest(identifier: "TIMER\(seconds)",
            content: content,
            trigger: trigger)
        
        // schedule notification by adding request to notification center
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
    print("OKOKOKOKOKOKOKOKOKOKOKOKOKOKOKOKOKOKOKOKOKOKOKOKOKOKOKOKOK")
    }
}
