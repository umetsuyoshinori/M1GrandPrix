//
//  ViewController.swift
//  MPMUSIC
//
//  Created by 梅津吉雅 on 2018/06/02.
//  Copyright © 2018年 梅津吉雅. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, MPMediaPickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    
    var player:MPMusicPlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        player = MPMusicPlayerController.applicationMusicPlayer
        //player = MPMusicPlayerController.systemMusicPlayer()
        
        // 再生中のItemが変わった時に通知を受け取る
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(type(of: self).nowPlayingItemChanged(notification:)), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        // 通知の有効化
        player.beginGeneratingPlaybackNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pick(sender: AnyObject) {
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
        
        // 選択した曲情報がmediaItemCollectionに入っているので、これをplayerにセット。
        player.setQueue(with: mediaItemCollection)
        
        // 選択した曲から最初の曲の情報を表示
        if let mediaItem = mediaItemCollection.items.first {
            updateSongInformationUI(mediaItem: mediaItem)
        }
        
        // ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)
        
    }

    /// 選択がキャンセルされた場合に呼ばれる
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        // ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)
    }
    
    /// 曲情報を表示する
    func updateSongInformationUI(mediaItem: MPMediaItem) {
        
        // 曲情報表示
        // (a ?? b は、a != nil ? a! : b を示す演算子です)
        // (aがnilの場合にはbとなります)
        artistLabel.text = mediaItem.artist ?? "不明なアーティスト"
        albumLabel.text = mediaItem.albumTitle ?? "不明なアルバム"
        songLabel.text = mediaItem.title ?? "不明な曲"
        
        // アートワーク表示
        if let artwork = mediaItem.artwork {
            let image = artwork.image(at: imageView.bounds.size)
            imageView.image = image
        } else {
            // アートワークがないとき
            // (今回は灰色表示としました)
            imageView.image = nil
            imageView.backgroundColor = UIColor.gray
        }
        
    }

    @IBAction func pushPlay(sender: AnyObject) {
        player.play()
    }
    
    @IBAction func pushPause(sender: AnyObject) {
        player.pause()
    }
    
    @IBAction func pushStop(sender: AnyObject) {
        player.stop()
    }
    
    
    /// 再生中の曲が変更になったときに呼ばれる
    @objc func nowPlayingItemChanged(notification: NSNotification) {
        
        if let mediaItem = player.nowPlayingItem {
            updateSongInformationUI(mediaItem: mediaItem)
        }
        
    }
    
    deinit {
        // 再生中アイテム変更に対する監視をはずす
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
        // ミュージックプレーヤー通知の無効化
        player.endGeneratingPlaybackNotifications()
    }
    
    
}
