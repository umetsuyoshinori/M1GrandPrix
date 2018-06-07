//
//  ViewController.swift
//  MPMUSIC
//
//  Created by 梅津吉雅 on 2018/06/02.
//  Copyright © 2018年 梅津吉雅. All rights reserved.
//

import UIKit
import MediaPlayer
import RealmSwift

class MPMUSICViewController: UIViewController, MPMediaPickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var repeatButton: UIButton!
    
    //プレイヤーのインスタンス作成
    var player = MPMusicPlayerController.applicationMusicPlayer
    
    //var sendText:String = ""
    
    //画面がロードされた途端に発動
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //プレイリスト(realm)に曲がないとき、曲選択へ強制的に飛ばす
        let realm = try! Realm()
        let num: Int = realm.objects(Song.self).count
        if num == 0{
            //picker()
        }
        else{//realm内に曲があるとき,先頭の曲の情報をセット
            let songArray = Common.realmColumnArray(column: "name")
            let albumArray = Common.realmColumnArray(column: "albam")
            let artistArray = Common.realmColumnArray(column: "artist")
            let imageArray = Common.realmColumnArray(column: "artworkId")
            
            songLabel.text = songArray[0] as? String
            albumLabel.text = albumArray[0] as? String
            artistLabel.text = artistArray[0] as? String
            imageView.image = imageArray[0] as? UIImage
        }
        
            //インスタンスを作成
            //player = MPMusicPlayerController.applicationMusicPlayer
        
            //フィルタリングしたクエリを作成
            let query = Query.tripleFilter(song: "クロノスタシス", albam: "フェイクワールドワンダーランド", artist: "きのこ帝国")

            //再生リストにクエリをセット
            player.setQueue(with: query!)
        
            //リピートボタンの形を決定
            let repeatStatus = player.repeatMode
            if repeatStatus == .one {
                repeatButton.setTitle("↺", for: .normal)
            }
            else if repeatStatus == .none {
                repeatButton.setTitle("→", for: .normal)
            }
        
            // 再生中のItemが変わった時に通知を受け取る
            let center = NotificationCenter.default
        
            center.addObserver(self,
                               selector: #selector(type(of: self).nowPlayingItemChanged(notification:)),
                               name: .MPMusicPlayerControllerNowPlayingItemDidChange,
                               object: player)
            // 通知の有効化
            player.beginGeneratingPlaybackNotifications()
        
    }
    

    
    //ボタンで曲の追加画面（ピッカー）を開く
//    @IBAction func pick(sender: AnyObject) {
//        picker()
//    }
    
    //ピッカーを開く
    func picker(){
        // MPMediaPickerControllerのインスタンスを作成
        let picker = MPMediaPickerController()
        // ピッカーのデリゲートを設定
        picker.delegate = self
        // 複数選択を可能にする。（falseにすると、単数選択になる）
        picker.allowsPickingMultipleItems = true
        // ピッカーを表示する
        present(picker, animated: true, completion: nil)
    }
    
    /// メディアアイテムピッカーでアイテムを選択完了したとき
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        //プレイヤーが動いているとき、止める
        //プレイヤーのインスタンス作成
        let player = MPMusicPlayerController.applicationMusicPlayer
        let playStatus = player.playbackState
        if playStatus == .playing {
            player.stop()
        }
        /*一旦,realmのDB内を初期化*/
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        //選択した曲情報がmediaItemCollection:[mediaItem]に入っているので、playerにセット。
        
        player.setQueue(with: mediaItemCollection)
        // 選択した曲情報をfor文で全てrealmに格納。
        var i: Int = 0
        for song in mediaItemCollection.items {
            song.writeRealmSongInfo(ID: i,CGSize: imageView.bounds.size)
            i += 1
        }
        
        
        // 選択した曲から最初の曲の情報を表示
//        if let mediaItem = mediaItemCollection.items.first{
//            mediaItem.updateSongInformationUI(ArtistLabel:artistLabel,
//                                              AlbamLabel:albumLabel,
//                                              NameLabel:songLabel,
//                                              imageView: imageView)
//        }
        
        // ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)
        
        //List画面へ飛ぶ
        self.performSegue(withIdentifier: "fromPlaytoList", sender: nil)
    }
    
//    //ボタンを押したらList画面へ飛ぶ
//    @IBAction func toList(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "fromPlaytoList", sender: nil)
//    }
    
    // 選択がキャンセルされた場合に呼ばれる
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        //realmになにもないとき、再生画面に戻れない
        let realm = try! Realm()
        let num: Int = realm.objects(Song.self).count
        if num == 0{
            self.performSegue(withIdentifier: "toOption", sender: nil)
            //dismiss(animated: true, completion: nil)
            //picker()
        }
        else{//realmになにかあるとき、
        // ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)    
        }
    }
    
    /// 再生中の曲が変更になったときに呼ばれる
    @objc func nowPlayingItemChanged(notification: NSNotification) {
        if let mediaItem = player.nowPlayingItem {
            mediaItem.updateSongInformationUI(ArtistLabel:artistLabel,
                                              AlbamLabel:albumLabel,
                                              NameLabel:songLabel,
                                              imageView: imageView)
        }
    }
    
    //再生と一時停止
    @IBAction func pushPlayorPause(sender: AnyObject) {
        let playStatus = player.playbackState
        if playStatus == .playing {
            player.pause()
        }
        else {
            player.play()
        }
    }
    //次の曲
    @IBAction func pushNext(sender: AnyObject) {
        player.skipToNextItem()
    }
    //前の曲
    @IBAction func pushPrevious(sender: AnyObject) {
        player.skipToPreviousItem()
    }
    //停止
    @IBAction func pushStop(sender: AnyObject) {
        player.stop()
    }
    //リピート有効
    @IBAction func ChangeRepeat(sender : AnyObject){
        let repeatStatus = player.repeatMode
        if repeatStatus == .one {
            player.repeatMode = .none
            repeatButton.setTitle("→", for: .normal)
        }
        else if repeatStatus == .none {
            player.repeatMode = .one
            repeatButton.setTitle("↺", for: .normal)
        }
    }
    
    //メモリ不足のときに発動
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {//このクラスのインスタンスがnilになるときに発動
        // 再生中アイテム変更に対する監視をはずす
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        // ミュージックプレーヤー通知の無効化
        player.endGeneratingPlaybackNotifications()
    }
}
