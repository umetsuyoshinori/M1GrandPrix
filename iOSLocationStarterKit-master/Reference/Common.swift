import RealmSwift

class Common: NSObject {
    class func realmColumnArray(column:String)-> Array<Any>{
            let realm = try! Realm()
            let cards = Array(realm.objects(Song.self))
            var array = [Any]()
            
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
                case "artwork":
                    //realmからid = iのartworkのimageのDataを取り出す
                    let data: Data = cards[i].artwork as Data
                    //Dataを画像に変換
                    let image = UIImage(data: data as Data)
                    //arrrayに追加
                    array.append(image!)
                default:
                    print("Type:Song has no such a member.")
                }
        }
        return array
    }
    
    class func locationMusicColumnArray(column:String)-> Array<Any>{
        let realmLocationMusic = try! Realm()
        let cards = Array(realmLocationMusic.objects(LocationMusic.self))
        var array = [Any]()
        
        let number: Int = cards.count
        for i in 0 ..< number{
            switch column{
            case "name":
                array.append(String(cards[i].name))
            case "albam":
                array.append(String(cards[i].album))
            case "artist":
                array.append(String(cards[i].artist))
            case "artwork":
                //realmからid = iのartworkのimageのDataを取り出す
                let data: Data = cards[i].artwork as Data
                //Dataを画像に変換
                let image = UIImage(data: data as Data)
                //arrrayに追加
                array.append(image!)
            case "latitude":
                array.append(String(cards[i].latitude))
            case "longitude":
                array.append(String(cards[i].longitude))
            case "date":
                array.append(String(cards[i].Date))
            default:
                print("Type:Song has no such a member.")
            }
        }
        return array
    }
}
