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
        self.table.delegate = self
        self.table.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*再生画面に移動する時*/
    @IBAction func backToPlay(_ sender: UIButton) {
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
//        let label1 = cell.viewWithTag(1) as! UILabel
//        var idArray = Common.realmColumnArray(column: "id")
//        label1.text = String(describing: idArray[indexPath.row])
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
        let img = Common.realmColumnArray(column: "artwork")[indexPath.row]
        imageView.image = img as? UIImage
        
        return cell
    }
    
    // Cell の高さを60にする
    func tableView(_ table: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }
}



