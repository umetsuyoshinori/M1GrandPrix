//位置情報と曲の情報をrealmに登録するためのクラス

import RealmSwift

class LocationMusic: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var album : String = ""
    @objc dynamic var artist : String = ""
    @objc dynamic var artwork : Data = Data()
    
    @objc dynamic var latitude : String = ""
    @objc dynamic var longitude : String = ""
    @objc dynamic var Date : String = ""
}
