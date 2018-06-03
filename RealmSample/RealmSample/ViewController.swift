//
//  ViewController.swift
//  RealmSample
//
//  Created by n00877 on 2017/01/17.
//  Copyright © 2017年 Sample. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //品名入力欄：変数textNameをstorybord上のUITextFieldとOutlet接続
    @IBOutlet weak var textName: UITextField!
    //金額入力欄：変数textPriceをstorybord上のUITextFieldとOutlet接続
    var textPrice = 123
    //購入履歴一覧：変数tableをstorybord上のUITableViewとOutlet接続
    @IBOutlet weak var table: UITableView!
    //記入者
    //@IBOutlet weak var textPerson: UITextField!
    //Itemクラスの変数itemListを定義
    var itemList: Results<Item>!
    
    //親クラスのviewDidLoad（画面が読み込まれた直後に発動するやつ）メソッドを上書き
    override func viewDidLoad() {
        //親クラスのviewDidLoadメソッドを使用
        super.viewDidLoad()
        // デフォルトRealmを取得
        let realm = try! Realm()
        // 一覧を取得：金額を条件に、登録日時が新しい順でソート
        self.itemList = realm.objects(Item.self).filter("price > 0").sorted(byKeyPath: "created", ascending: false)
    }

    //親クラスのdidReceiveMemoryWarning（メモリ不足で発動するやつ）を上書き
    override func didReceiveMemoryWarning() {
        //親クラスのdidReceiveMemoryWarningを使用
        super.didReceiveMemoryWarning()
    }
    
    /* realmに追加の処理　ここから *///////////////////////////////////////
    //登録ボタン：押下時に発動
    @IBAction func actionAdd(_ sender: AnyObject) {
        /* 入力値をセット */
        //Itemクラスのインスタンスitemを定義
        let item:Item = Item()
        //itemの要素nameには，このクラス（ViewController）のメンバーtextName（UITextFieldクラス）のメンバーtextを代入する
        item.name = self.textName.text
        //itemの要素personには，このクラス（ViewController）のメンバーtextPerson（Stringクラス）のメンバーtextを代入する
        //item.person = self.textPerson.text
        //このクラス（ViewController）のメンバーtextPrice（UITextFieldクラス）のメンバーtext(nil可)の文字数が１以上の時，
        if ((String(self.textPrice).utf8CString.count) > 0) {
            //インスタンスitemのメンバーpriceに，textPrice（UITextFieldクラス）のメンバーtextを整数に変換し，代入
            item.price = Int(self.textPrice)//※textにInt()を適用するから，textはもともと数でないといけない
        }
        else {
            item.price = 1
        }
        
        // インサート実行
        let realm = try! Realm()
        try! realm.write {
            //realmにitemを追加
            realm.add(item)
        }
        
        // クエリの実行結果は自動的に最新の状態に更新される⇒再度取得する必要がない
        //self.itemList = realm.objects(Item.self).filter("price > 0").sorted(byProperty: "created", ascending: true)
        
        // テーブルを再読込
        self.table.reloadData()

    }
     /* realmに追加の処理　ここまで *///////////////////////////////////////

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ItemListCell = tableView.dequeueReusableCell(withIdentifier: "ItemListCell")! as! ItemListCell
        
        // 行取得
        let item: Item = self.itemList[(indexPath as NSIndexPath).row];
        // 品名
        cell.lblName.text = item.name
        // 記入者
        //cell.lblPerson.text = item.person
        // 金額
        cell.lblPrice.text = self.convert(price: item.price)
        // 登録日時
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd' 'HH:mm:ss"
        cell.lblDate.text = formatter.string(from: item.created)
        
        return cell
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
    }


    /* 金額表示用に変換 */
    private func convert(price: Int) -> String
    {
        let decimalFormatter = NumberFormatter()//新たにフォーマットを作ります、詳細は以下で追記
        decimalFormatter.numberStyle = NumberFormatter.Style.decimal//１０進数(多分)
        decimalFormatter.groupingSeparator = ","//コンマを打つ
        decimalFormatter.groupingSize = 3 //3桁ごとに
        return "¥"+decimalFormatter.string(from: price as NSNumber)!//フォーマットに従って金額を返す
    }

}

