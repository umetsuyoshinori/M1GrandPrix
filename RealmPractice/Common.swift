import RealmSwift

class Common: NSObject {
    class func realmColumnArray(column:String)-> Array<Any>{
            let realm = try! Realm()
            let cards = Array(realm.objects(Song.self))
            let images = Array(realm.objects(Artwork.self))
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
                case "artworkId":
                    //realm内のi番目の要素のartworkIdをawidとおく
                    let awid = cards[i].artworkId
                    //realmからid = artworkIdのimageのDataを取り出す
                    let data: Data = images[awid].imageData! as Data
                    //Dataを画像に変換
                    let image = UIImage(data: data as Data)
                    //arrrayに追加
                    array.append(image ?? UIImage(named: "music.png")!)
                default:
                    print("Type:Song has no such a member.")
                }
        }
        return array
    }
}
