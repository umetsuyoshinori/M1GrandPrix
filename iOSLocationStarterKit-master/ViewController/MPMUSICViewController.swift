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
import MapKit

class MPMUSICViewController: UIViewController, MPMediaPickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var playpause: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    
    // MPMediaPickerControllerのインスタンスを作成
    let Picker = MPMediaPickerController()
    
    //音楽のシングルトン呼び出し
    let player = MusicService().player
    
    //位置のシングルトン呼び出し
    let sharedInstance = LocationService()
    
    //位置情報のコンストラクタ
    var location = CLLocation()
    
    //画面がロードされた途端に発動
    override func viewDidLoad() {
        super.viewDidLoad()
        //音楽のシングルトン呼び出し
        //let sharedMusic = MusicService()
        //let player = sharedMusic.player
        
        Picker.delegate = self
        
        let state = player.playbackState
        if state != .playing{
        //テキストとジャケ写の初期値
        songLabel.text = "Let's"
        albumLabel.text = "Enjoy"
        artistLabel.text = "Music"
        imageView.image = UIImage(named: "music")
        }

        
        // 再生中のItemが変わった時に通知を受け取るサービスを設定
        let center = NotificationCenter.default
        
        center.addObserver(self,
                           selector: #selector(type(of: self).nowPlayingItemChanged(notification:)),
                           name: .MPMusicPlayerControllerNowPlayingItemDidChange,
                           object: player)
        // 通知の有効化
        player.beginGeneratingPlaybackNotifications()
        
        /**********位置***********/

        //シングルトンのロケーションマネージャを利用
        let locationManager = sharedInstance.locationManager
        locationManager.requestLocation()
        //ロケーションのアップデートを監視し，適宜realmを発動
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLocation(_:)), name: Notification.Name(rawValue:"didUpdateLocation"), object: nil)
    }
    
    //ビューが表示される直前、何度でも
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        //今の再生リストの曲数が
        let realm = try! Realm()
        let nowSongNumber = realm.objects(Song.self).count
        if nowSongNumber > 0 {//0より上なら
            //何もしない
        }
        else{//0なら
            picker()// 曲を選ばせる
        }
        
        
        //再生中なら、
        let state = player.playbackState
        if state == .playing {//再生中のアイテムの情報を画面にセット
            songLabel.text = player.nowPlayingItem?.title
            albumLabel.text = player.nowPlayingItem?.albumTitle
            artistLabel.text = player.nowPlayingItem?.artist
            let alterImage = UIColor.random.image(imageView.bounds.size)
            imageView.image = player.nowPlayingItem?.artwork?.image(at: CGSize(width:375,height:375)) ?? alterImage
            
            //再生，一時停止ボタンを一時停止の形に変更
            playpause.setTitle("▯▯", for: [])
            
        }
        //状態に応じてリピートボタンの形を決定
        ChangeRepeatShape()
        //状態に応じてシャッフルボタンの形を決定
        ChangeShuffleShape()

    }
    
    //ビューが表示された直後、何度でも
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    
    //通知内容を元に,マップを更新する
    @objc func updateLocation(_ notification: NSNotification){
        //通知に含まれるuserInfo(辞書型)がnilでなかったら
        if let userInfo = notification.userInfo{
            //さらに，userInfoが"location"キーに対する値をもつ時
            if let newLocation = userInfo["location"] as? CLLocation{
                //このクラスの変数locationを新たなものに更新
                self.location = newLocation
            }
        }
    }
    
    
    //ボタンで曲の追加画面（ピッカー）を開く
        @IBAction func pick(sender: AnyObject) {
            picker()
        }
    
    //ピッカーを開く
    func picker(){
        // 複数選択を可能にする。（falseにすると、単数選択になる）
        Picker.allowsPickingMultipleItems = true
        // ピッカーを表示する
        present(Picker, animated: true, completion: nil)
    }
    
    /// メディアアイテムピッカーでアイテムを選択完了したとき
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {

        /*一旦,realmのDB内を初期化*/
        let realm = try! Realm()
        let Songs = realm.objects(Song.self)
        try! realm.write {
            // Realmに保存されているSong型のオブジェクトを全て削除
            realm.delete(Songs)
        }
        // 選択した曲情報をfor文で全てrealmに格納。
        var i: Int = 0
        for song in mediaItemCollection.items {
            song.writeRealmSongInfo(ID: i,CGSize: imageView.bounds.size)
            i += 1
        }

        //プレイヤーを止める
        self.player.stop()

        //選択した曲情報がmediaItemCollection:[mediaItem]に入っているので、playerにセット。
        player.setQueue(with: mediaItemCollection)

        //再生
        player.play()

        // ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)

        }

    // 選択がキャンセルされた"直後"に呼ばれる
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        //ピッカーを破棄
        dismiss(animated: true, completion: nil)
    }

    /// 再生中の曲が変更になったら発動
    @objc func nowPlayingItemChanged(notification: NSNotification) {
        //新しい曲の情報を画面に表示
        if let mediaItem = player.nowPlayingItem {
            mediaItem.updateSongInformationUI(ArtistLabel:artistLabel,
                                              AlbamLabel:albumLabel,
                                              NameLabel:songLabel,
                                              imageView: imageView)

            //新しい曲の情報と緯度，経度，時刻をrealmLocationMusicに登録
            mediaItem.writeLocationMusic(CLLocation: self.location)
        }


    }
    
    //再生と一時停止
    @IBAction func pushPlayorPause(sender: AnyObject) {
        let playStatus = player.playbackState
        if playStatus == .playing {
            player.pause()
            playpause.setTitle("▷", for: [])
        }
        else {
            player.play()
            playpause.setTitle("▯▯", for: [])
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

    //シャッフル状態とボタン形状を変更
    @IBAction func ChangeShuffle(sender : AnyObject){
        ChangeShuffleState()
        ChangeShuffleShape()
    }
    
    //シャッフルボタンの形を変更
    func ChangeShuffleShape(){
        let shuffleStatus = player.shuffleMode
        if shuffleStatus == .off {
            shuffleButton.setTitle("→", for: .normal)
        }
        else if shuffleStatus == .songs {
            shuffleButton.setTitle("⤮", for: .normal)
        }
    }
    
    //シャッフル状態を変更
    func ChangeShuffleState(){
        let shuffleStatus = player.shuffleMode
        if shuffleStatus == .off {
            player.shuffleMode = .songs
        }
        else if shuffleStatus == .songs {
            player.shuffleMode = .off
        }
    }
    
    //リピート状態とボタン形状を変更
    @IBAction func ChangeRepeat(sender : AnyObject){
        ChangeRepeatState()
        ChangeRepeatShape()

    }
    
    //リピートボタンの形を変更
    func ChangeRepeatShape(){
        let repeatStatus = player.repeatMode
        if repeatStatus == .one {
            repeatButton.setTitle("↻1", for: .normal)
        }
        else if repeatStatus == .none {
            repeatButton.setTitle("→", for: .normal)
        }
    }
    
    //リピート状態を変更
    func ChangeRepeatState(){
        let repeatStatus = player.repeatMode
        if repeatStatus == .one {
            player.repeatMode = .none
        }
        else if repeatStatus == .none {
            player.repeatMode = .one
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

