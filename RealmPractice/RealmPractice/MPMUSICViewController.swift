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
    
    var player:MPMusicPlayerController!
    
    var sendText:String = ""
    
    //画面がロードされた途端に発動
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //プレイリスト(realm)に曲がないとき、曲選択へ強制的に飛ばす
        if sendText == "NO MUSIC, NO LIFE"{
            picker()
        }
        
        
        //インスタンスを作成
        player = MPMusicPlayerController.applicationMusicPlayer
        
        //リピートボタンの形を決定
        let repeatStatus = player.repeatMode
        if repeatStatus == .one {
            repeatButton.setTitle("↺", for: .normal)
        }
        else if repeatStatus == .none {
            repeatButton.setTitle("→", for: .normal)
        }
        
        //リピートをやめる
        //player.repeatMode = .none
        
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
    @IBAction func pick(sender: AnyObject) {
        picker()
    }
    
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
    
    /// メディアアイテムピッカーでアイテムを選択完了したときに呼び出される
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        // プレイヤーを止める
        player.stop()
        /*一旦,realmのDB内を初期化*/
        allDeleteRealm()
        //選択した曲情報がmediaItemCollection:[mediaItem]に入っているので、playerにセット。
        player.setQueue(with: mediaItemCollection)
        // 選択した曲情報をfor文で全てrealmに格納。
        var i: Int = 0
        for song in mediaItemCollection.items {
            writeRealmSongInfo(mediaItem: song,ID: i)
            i += 1
        }
        // 選択した曲から最初の曲の情報を表示
        print(String(describing: type(of: mediaItemCollection)))
        if let mediaItem = mediaItemCollection.items.first {
            updateSongInformationUI(mediaItem: mediaItem)
        }
        //次回以降ロード時に強制的に曲選択に飛ばされないよう、sendTextを変更
        sendText = "ENJOY MUSIC"
        // ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)
    }
    
    // 選択がキャンセルされた場合に呼ばれる
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        //sendTextが"NO MUSIC, NO LIFE"のとき、再生画面に戻れない
        if sendText == "NO MUSIC, NO LIFE" {
        }
        else{//sendTextが"NO MUSIC, NO LIFE"でないとき、
        // ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)
        }
    }
    
    /// 曲情報を表示する
    func updateSongInformationUI(mediaItem: MPMediaItem) {
        //ラベルに各情報を表示
        artistLabel.text = mediaItem.artist ?? "不明なアーティスト"
        albumLabel.text = mediaItem.albumTitle ?? "不明なアルバム"
        songLabel.text = mediaItem.title ?? "不明な曲"
        
        // アートワーク表示
        if let artwork = mediaItem.artwork {
            let image = artwork.image(at: imageView.bounds.size)
            imageView.image = image
        }
        else {// アートワークがないとき
            imageView.image = nil
            imageView.backgroundColor = UIColor.gray
        }
    }
    
    //realm内の全ての曲情報を消す
    func allDeleteRealm() {
        let realm = try! Realm()
        let allSong = realm.objects(Song.self)
        allSong.forEach { song in
            try! realm.write() {
                realm.delete(song)
            }
        }
    }

    //ある曲の情報をIDとともにrealmに追加する
    func writeRealmSongInfo(mediaItem: MPMediaItem,ID: Int) {
        /*レコードの書き込み*/
        let realm = try! Realm()
        let X = Song()
        
        X.id = ID
        X.name = mediaItem.title ?? "不明な曲"
        X.albam = mediaItem.albumTitle ?? "不明なアルバム"
        X.artist = mediaItem.artist ?? "不明なアーティスト"
        X.artworkId = X.id
        //realmに曲情報を書き込み
        try! realm.write() {
            realm.add(X)
        }
    
        /*レコードの書き込み*/
        //artworkと曲のidを紐付けるDB,realmを構築
        let Y = Artwork()
        
        //オレンジ色の四角いUIImageを生成
        let orange = UIColor.orange.image(imageView.bounds.size)
        let orangeData = UIImagePNGRepresentation(orange)

        //アルバムのアートワーク(CGサイズはimageViewの大きさ)を生成
        let anArtwork = mediaItem.artwork?.image(at: imageView.bounds.size)
        let anArtworkData = UIImagePNGRepresentation(anArtwork!)
        
        //realmに曲のIDと画像を入れていく(サイズはimageViewの大きさ)
        Y.id = ID
        Y.imageData = anArtworkData as! NSData ?? orangeData as! NSData
        //書き込み
        try! realm.write() {
            realm.add(Y)
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
    
    /// 再生中の曲が変更になったときに呼ばれる
    @objc func nowPlayingItemChanged(notification: NSNotification) {
        if let mediaItem = player.nowPlayingItem {
            updateSongInformationUI(mediaItem: mediaItem)
        }
    }
    
    deinit {//このクラスのインスタンスがnilになるときに発動
        // 再生中アイテム変更に対する監視をはずす
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        // ミュージックプレーヤー通知の無効化
        player.endGeneratingPlaybackNotifications()
    }
}
