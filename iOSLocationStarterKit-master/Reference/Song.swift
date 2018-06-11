import RealmSwift

/**RealmSwiftに含まれるObject型を継承したクラスを作ります。
 プロパティはdynamic varで宣言します。*/
class Song: Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var name : String! = nil
    @objc dynamic var albam : String! = nil
    @objc dynamic var artist : String! = nil
    @objc dynamic var artwork : Data! = nil
    
}
