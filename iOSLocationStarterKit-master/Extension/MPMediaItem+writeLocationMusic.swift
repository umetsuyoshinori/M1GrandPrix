//
//  m.swift
//  RealmPractice
//
//  Created by 梅津吉雅 on 2018/06/05.
//  Copyright © 2018年 梅津吉雅. All rights reserved.
//

import Foundation
import RealmSwift
import MediaPlayer
import MapKit

extension MPMediaItem {
    func writeLocationMusic(CLLocation: CLLocation) {
        let cgSize: CGSize = CGSize(width:100, height:100)
        /*レコードの準備*/
        /*曲名，アルバム名，アーティスト名，ジャケ写データのレコード*/
        let Y = LocationMusic()
        Y.name = self.title ?? "不明な曲"
        Y.album = self.albumTitle ?? "不明なアルバム"
        Y.artist = self.artist ?? "不明なアーティスト"
        
        //四角いランダムな色のUIImageを生成
        let random = UIColor.random.image(cgSize)
        let randomData = UIImagePNGRepresentation(random)
        //アルバムのアートワーク(CGサイズはimageViewの大きさ)を生成
        let anArtwork = self.artwork
        let anArtworkData: Data
        if anArtwork == nil{
            anArtworkData = randomData!
        }
        else{
            anArtworkData = UIImagePNGRepresentation(anArtwork!.image(at: cgSize)!)!
        }
        
        //ジャケ写
        Y.artwork = anArtworkData as Data
        
        //緯度
        Y.latitude = String(CLLocation.coordinate.latitude)
        //経度
        Y.longitude = String(CLLocation.coordinate.longitude)
        //時刻
        Y.Date = CLLocation.timestamp.description
        
        
        /*realmLocationMusicにレコード書き込み*/
        let realmLocationMusic = try! Realm()
        try! realmLocationMusic.write() {
            realmLocationMusic.add(Y)
        }
    }
    
}
