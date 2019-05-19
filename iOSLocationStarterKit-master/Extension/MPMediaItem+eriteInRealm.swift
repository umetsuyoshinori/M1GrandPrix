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

extension MPMediaItem {
    func writeRealmSongInfo(ID: Int,CGSize: CGSize) {
    /*レコードの準備*/
        /*id，曲名，アルバム名，アーティスト名，ジャケ写のレコード*/
        let X = Song()
        
        X.id = ID
        X.name = self.title ?? "不明な曲"
        X.albam = self.albumTitle ?? "不明なアルバム"
        X.artist = self.artist ?? "不明なアーティスト"
        
        //四角いランダムな色のUIImageを生成
        let orange = UIColor.random.image(CGSize)
        let orangeData = UIImagePNGRepresentation(orange)
        //アルバムのアートワーク(CGサイズはimageViewの大きさ)を生成
        let anArtwork = self.artwork
        
        let anArtworkData: Data
        if anArtwork == nil{
            anArtworkData = orangeData!
        }
        else{
            anArtworkData = UIImagePNGRepresentation(anArtwork!.image(at: CGSize)!)!
        }
        
        //ジャケ写
        X.artwork = anArtworkData as Data
        
    /*realmにレコード書き込み*/
        let realm = try! Realm()
        try! realm.write() {
            realm.add(X)
        }
    }
    
}
