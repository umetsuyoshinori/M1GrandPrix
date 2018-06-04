//
//  ViewController.swift
//  RealmPractice
//
//  Created by 梅津吉雅 on 2018/06/04.
//  Copyright © 2018年 梅津吉雅. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*realm起動的な*/
        let realm = try! Realm()
        
        
        /*レコードの書き込み*/
        let X = Song()
        let Y = Song()
        let Z = Song()
        
        X.id = 0
        X.name = "終わりなき旅"
        X.albam = "DISCOVERY"
        X.artist = "Mr.Children"
        X.artworkId = 0
        
        Y.id = 1
        Y.name = "ヒロイン"
        Y.albam = "アンコール"
        Y.artist = "back number"
        Y.artworkId = 1
        
        Z.id = 2
        Z.name = "君という花"
        Z.albam = "君繋ファイブエム"
        Z.artist = "ASIAN KUNG-FU GENERATION"
        Z.artworkId = 2
        
        //realm.write()の中でrealm.add()を呼び出し,引数には生成したRealmのオブジェクトを渡します。
        try! realm.write() {
            realm.add(X);
            realm.add(Y);
            realm.add(Z)
        }
        
        
        
        /*レコードの更新*/
        //取得したSong型の配列の一番最初の要素のartistを"マキシマムザホルモン"に変更
        let firstSong = realm.objects(Song.self).first
        
        try! realm.write() {
            firstSong?.artist = "マキシマムザホルモン"
        }
        
        //artistが"Mr.Children"のSong型オブジェクトを全て取得し、artistを"田中"に変更
        let allSongs = realm.objects(Song.self).filter("artist like 'Mr.Children'")
        
        allSongs.forEach { misuchiru in
            try! realm.write() {
                misuchiru.name = "田中"
            }
        }
        
        //ラベルにて確認
        Label.text = firstSong?.artist
        
        
        
        
        /*レコードの読み込み*/
        //特定の型(ここではSong)のレコードを全件取得
//        realm.objects(Song.self)
        
        //idカラムが0以上のレコードを全件取得（数値）
//        realm.objects(Song.self).filter("id >= 0")
        
        //albamカラムで 'DISCOVERY' の文字列と一致するレコードを全件取得(文字列, NSPredicate)
//        realm.objects(Song.self).filter("albam like 'DISCOVERY'")

        //artistカラムに 'n' の文字列を含むレコードを全件取得(文字列, NSPredicate)
//        realm.objects(Song.self).filter("artist contains 'n'")
        
    
        
//        /*レコードの削除*/
//        //取得したSong型の配列の一番最初のオブジェクトを削除
//
//        if let firstSong = realm.objects(Song.self).first {
//            try! realm.write() {
//                realm.delete(firstSong)
//            }
//        }
//
//        //albamがDISCOVERYのオブジェクトを全件削除
//        let SongInDISCOVERY = realm.objects(Song.self).filter("albam like 'DISCOVERY'")
//
//        SongInDISCOVERY.forEach { song in
//            try! realm.write() {
//                realm.delete(song)
//            }
//        }
        
        
        
    }
        

    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }


}
