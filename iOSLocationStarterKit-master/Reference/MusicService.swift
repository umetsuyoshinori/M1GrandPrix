import UIKit
import CoreLocation
import MediaPlayer

public class MusicService: NSObject {
    
    public static var sharedInstance = MusicService()
    var player = MPMusicPlayerController.applicationMusicPlayer
    //位置のシングルトン呼び出し
    let sharedLocation = LocationService()
    //位置情報のコンストラクタ
    var location = CLLocation()
    //
    var mediaItem = MPMediaItem()
    
    override init(){
        super.init()

//        // 再生中のItemが変わった時に通知を受け取るサービスを設定
//        let center = NotificationCenter.default
//
//        center.addObserver(
//            self,
//            selector: #selector(type(of: self).nowPlayingItemChanged(_:)),
//            name: .MPMusicPlayerControllerNowPlayingItemDidChange,
//            object: player
//        )
//
//        // 外部への通知の有効化
//        player.beginGeneratingPlaybackNotifications()
        
//        //シングルトンのロケーションマネージャを利用
//        let locationManager = sharedLocation.locationManager
//        locationManager.requestLocation()
//        //ロケーションのアップデートを監視し，適宜realmを発動
//        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLocation(_:)), name: Notification.Name(rawValue:"didUpdateLocation"), object: nil)
    }
    
//    /// 再生中の曲が変更になったら発動
//    @objc public func nowPlayingItemChanged(_ notification: NSNotification) {
//        //新しい曲があるときは
//        self.mediaItem = player.nowPlayingItem!
//        if mediaItem != nil {
//            //新しい曲の情報と緯度，経度，時刻をrealmLocationMusicに登録
//            mediaItem.writeLocationMusic(CLLocation: self.location)
//        }
//    }
    
//    //通知内容を元に,マップを更新する
//    @objc func updateLocation(_ notification: NSNotification){
//        //通知に含まれるuserInfo(辞書型)がnilでなかったら
//        if let userInfo = notification.userInfo{
//            //さらに，userInfoが"location"キーに対する値をもつ時
//            if let newLocation = userInfo["location"] as? CLLocation{
//                //このクラスの変数locationを新たなものに更新
//                self.location = newLocation
//            }
//        }
//    }
}
