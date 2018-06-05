import UIKit
import RealmSwift
import MediaPlayer

class PlaylistViewController: UIViewController,MPMediaPickerControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
/*ここからメディアピッカー*/
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
        //player.stop()
        
        // 選択した曲情報がmediaItemCollectionに入っているので、これをplayerにセット。
        //player.setQueue(with: mediaItemCollection)
        
        // 選択した曲から最初の曲の情報を表示
//        if let mediaItem = mediaItemCollection.items.first {
//            updateSongInformationUI(mediaItem: mediaItem)
//        }
        
        // ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)
        
    }
    
    /// 選択がキャンセルされた場合に呼ばれる
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        // ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)
    }
/*ここまでメディアピッカー*/
    
    //配列作成用の関数を定義
    func realmColumn(column: String) -> Array<Any> {
        let realm = try! Realm()
        let cards = Array(realm.objects(Song.self))
        var array = [Any]()
        
        let images = Array(realm.objects(Artwork.self))
        
        let number: Int = cards.count
        for i in 0 ..< number{
            switch column{
            case "id":
                array.append(cards[i].id)
            case "name":
                array.append(String(cards[i].name))
            case "albam":
                array.append(String(cards[i].albam))
            case "artist":
                array.append(String(cards[i].artist))
            case "artworkId":
                //realm内のi番目の要素のartworkIdをawidとおく
                let awid = cards[i].artworkId
                //realmAWからid = artworkIdのimageのDataを取り出す
                let data: NSData = images[awid].imageData!
                //Dataを画像に変換
                let image = UIImage(data: data as Data)
                //arrrayに追加
                array.append(image)
            default:
                print("Type:Song has no such a member.")
            }
        }
        return array
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //テーブルビューのセル数は登録されている曲数に一致
        let realm = try! Realm()
        return Array(realm.objects(Song.self)).count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        // Tag番号 1 で UILabel インスタンスの生成
        let label1 = cell.viewWithTag(1) as! UILabel
        var idArray = realmColumn(column: "id")
        label1.text = String(describing: idArray[indexPath.row])
        // Tag番号 2 で UILabel インスタンスの生成
        let label2 = cell.viewWithTag(2) as! UILabel
        var nameArray = realmColumn(column: "name")
        label2.text = String(describing: nameArray[indexPath.row])
        // Tag番号 3 で UILabel インスタンスの生成
        let label3 = cell.viewWithTag(3) as! UILabel
        var albamArray = realmColumn(column: "albam")
        label3.text = String(describing: albamArray[indexPath.row])
        // Tag番号 4 で UILabel インスタンスの生成
        let label4 = cell.viewWithTag(4) as! UILabel
        var artistArray = realmColumn(column: "artist")
        label4.text = String(describing: artistArray[indexPath.row])
        // Tag番号 5 で UIImageView インスタンスの生成
        let imageView = cell.viewWithTag(5) as! UIImageView
          //realm内全データのartworkId列の配列:[Int]
        let imageArray = realmColumn(column: "artworkId")
        let img = UIImage(named: imageArray[indexPath.row] as! String)
        imageView.image = img
        
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


    

