import UIKit
import RealmSwift
import MediaPlayer

class PlaylistViewController: UIViewController,
//MPMediaPickerControllerDelegate,
UITableViewDelegate,
UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
///*ここからメディアピッカー*/
//    var player = MPMusicPlayerController.applicationMusicPlayer
//    //ボタンで曲の追加画面（ピッカー）を開く
////    @IBAction func pick(sender: AnyObject) {
////        picker()
////    }
////
//    //ピッカーを開く
//    func picker(){
//        // MPMediaPickerControllerのインスタンスを作成
//        let picker = MPMediaPickerController()
//        // ピッカーのデリゲートを設定
//        picker.delegate = self
//        // 複数選択を可能にする。（falseにすると、単数選択になる）
//        picker.allowsPickingMultipleItems = true
//        // ピッカーを表示する
//        present(picker, animated: true, completion: nil)
//    }
//
//    /// メディアアイテムピッカーでアイテムを選択完了したとき
//    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
//        // 新しいDB,realmBを展開,リセット
//        let realmB = try! Realm()
//        try! realmB.write {
//            realmB.deleteAll()
//        }
//        //一度，選んだ曲をrealmBに入れる
//        var i: Int = 0
//        for song in mediaItemCollection.items {
//            song.writeRealmSongInfo(ID: i,CGSize: CGSize(width: 375, height: 375))
//            i += 1
//        }
//        //選んだ曲リスト
//        let pickedSongList = realmB.objects(Song.self)
//
//        //今realmnに入ってる曲リスト
//        let realm = try! Realm()
//        let nowSongList = realm.objects(Song.self)
//
//        /*選んだ曲とrealm内の曲を比較*/
//        //一致
//        if pickedSongList == nowSongList {
//            //と一緒だったら何もしない
//        }
//        //不一致
//        else{
//            /*一旦,realmのDB内を初期化*/
//            let realm = try! Realm()
//            try! realm.write {
//                realm.deleteAll()
//            }
//            // 選択した曲情報をfor文で全てrealmに格納。
//            var i: Int = 0
//            for song in mediaItemCollection.items {
//                song.writeRealmSongInfo(ID: i,CGSize: CGSize(width: 375, height: 375))
//                i += 1
//            }
//            // 選択した曲から最初の曲の情報を表示
//
//            // ピッカーを閉じ、破棄する
//            dismiss(animated: true, completion: nil)
//
//            //画面を再読込
//            loadView()
//            viewDidLoad()
//        }
//    }
//
//    /// 選択がキャンセルされた場合に呼ばれる
//    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
//        // ピッカーを閉じ、破棄する
//        dismiss(animated: true, completion: nil)
//    }
///****************************************************/
    
/*再生画面に移動する時*/
    @IBAction func backToPlay(_ sender: UIButton) {
//        //選んだ曲リスト
//        let realmB = try! Realm()
//        let pickedSongList = realmB.objects(Song.self)
//
//        //今realmnに入ってる曲リスト
//        var realm = try! Realm()
//        let nowSongList = realm.objects(Song.self)
//
//        /*選んだ曲とrealm内の曲を比較*/
//        //一致
//        if pickedSongList == nowSongList {
//            //と一緒だったらただ戻る
//        }
//            //不一致なら，曲をセットしてもどる
//        else{
//            /*一旦,realmのDB内を初期化*/
//            try! realm.write {
//                realm.deleteAll()
//            }
//            // 選択した曲情報をfor文で全てrealmに格納。
//            try! realm.write {
//                realm = realmB
//            }
////            var i: Int = 0
////            for song in mediaItemCollection.items {
////                song.writeRealmSongInfo(ID: i,CGSize: CGSize(width: 375, height: 375))
////                i += 1
////            }
//
//            //フィルタリングしたクエリを作成
//            let query = Query.tripleFilter(song: "クロノスタシス", albam: "フェイクワールドワンダーランド", artist: "きのこ帝国")
//            // プレイヤーを止める
//            player.stop()
//            //選択した曲情報をクエリを元にplayerにセット。
//
//            player.setQueue(with: query!)
//
            //再生画面に戻る
            self.performSegue(withIdentifier: "fromListToPlay", sender: nil)
        }
/****************************************************/

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //テーブルビューのセル数は登録されている曲数に一致
        let realm = try! Realm()
        return Array(realm.objects(Song.self)).count
    }
    //tableviewに配列の情報を入れていく
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        // Tag番号 1 で UILabel インスタンスの生成
        let label1 = cell.viewWithTag(1) as! UILabel
        var idArray = Common.realmColumnArray(column: "id")
        label1.text = String(describing: idArray[indexPath.row])
        // Tag番号 2 で UILabel インスタンスの生成
        let label2 = cell.viewWithTag(2) as! UILabel
        var nameArray = Common.realmColumnArray(column: "name")
        label2.text = String(describing: nameArray[indexPath.row])
        // Tag番号 3 で UILabel インスタンスの生成
        let label3 = cell.viewWithTag(3) as! UILabel
        var albamArray = Common.realmColumnArray(column: "albam")
        label3.text = String(describing: albamArray[indexPath.row])
        // Tag番号 4 で UILabel インスタンスの生成
        let label4 = cell.viewWithTag(4) as! UILabel
        var artistArray = Common.realmColumnArray(column: "artist")
        label4.text = String(describing: artistArray[indexPath.row])
        // Tag番号 5 で UIImageView インスタンスの生成
        let imageView = cell.viewWithTag(5) as! UIImageView
          //realm内全データのartworkId列の配列:[Int]
        let img = Common.realmColumnArray(column: "artworkId")[indexPath.row]
        imageView.image = img as? UIImage
        
        return cell
    }
    
    // Cell の高さを１２０にする
    func tableView(_ table: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }
}



