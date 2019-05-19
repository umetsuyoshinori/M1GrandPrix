//
//  TestViewController.swift
//  LocationStarterKit
//
//  Created by 梅津吉雅 on 2018/06/09.
//  Copyright © 2018年 Goldrush Computing Inc. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class TestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        //シングルトン呼び出し
        let sharedInstance = LocationService()
        let locationManager = sharedInstance.locationManager
        locationManager.requestLocation()
        //ロケーションのアップデートを監視し，適宜realmを発動
        NotificationCenter.default.addObserver(self, selector: #selector(TestViewController.updateMap(_:)), name: Notification.Name(rawValue:"didUpdateLocation"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Button(_ sender: Any) {
        LocationService().request()
        label2.text = String(arc4random())
    }
    
    //通知内容を元に,テーブルビューのロウを追加する
    @objc func updateMap(_ notification: NSNotification){
        //通知に含まれるuserInfo(辞書型)がnilでなかったら
        if let userInfo = notification.userInfo{
            //さらに，userInfoが"location"キーに対する値をもつ時
            if let newLocation = userInfo["location"] as? CLLocation{
                label.text = String(newLocation.coordinate.latitude)
            }
            
        }
    }
    

    // ボタンを押下した時にアラートを表示するメソッド
    @IBAction func dispAlert(sender: UIButton) {
        
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "アラート表示", message: "保存してもいいですか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //テーブルビューのセル数は登録されている曲数に一致
        let realmLocationMusic = try! Realm()
        return Array(realmLocationMusic.objects(LocationMusic.self)).count
    }
    //tableviewに配列の情報を入れていく
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        //Tag番号 1 で UILabel インスタンスの生成
        let label1 = cell.viewWithTag(1) as! UILabel
        var nameArray = Common.locationMusicColumnArray(column: "name")
        label1.text = String(describing: nameArray[indexPath.row])
        // Tag番号 2 で UILabel インスタンスの生成
        let label2 = cell.viewWithTag(2) as! UILabel
        var albamArray = Common.locationMusicColumnArray(column: "albam")
        label2.text = String(describing: albamArray[indexPath.row])
        // Tag番号 3 で UILabel インスタンスの生成
        let label3 = cell.viewWithTag(3) as! UILabel
        var artistArray = Common.locationMusicColumnArray(column: "artist")
        label3.text = String(describing: artistArray[indexPath.row])
        
        //Tag番号 4 で UIImageView インスタンスの生成
        let imageView = cell.viewWithTag(4) as! UIImageView
        let img = Common.locationMusicColumnArray(column: "artwork")[indexPath.row]
        imageView.image = img as? UIImage
        
        // Tag番号 5 で UILabel インスタンスの生成
        let label5 = cell.viewWithTag(5) as! UILabel
        var latitudeArray = Common.locationMusicColumnArray(column: "latitude")
        label5.text = String(describing: latitudeArray[indexPath.row])
        // Tag番号 6 で UILabel インスタンスの生成
        let label6 = cell.viewWithTag(6) as! UILabel
        var longitudeArray = Common.locationMusicColumnArray(column: "longitude")
        label6.text = String(describing: longitudeArray[indexPath.row])
        // Tag番号 7 で UILabel インスタンスの生成
        let label7 = cell.viewWithTag(7) as! UILabel
        var dateArray = Common.locationMusicColumnArray(column: "date")
        label7.text = String(describing: dateArray[indexPath.row])
        
        return cell
    }
    
    // Cell の高さを70にする
    func tableView(_ table: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }
}




