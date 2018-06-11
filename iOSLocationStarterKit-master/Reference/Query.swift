import MediaPlayer
//曲名、アルバム、アーティスト名で絞り込むクエリ
class Query: NSObject {
    class func tripleFilter(song: String,albam: String, artist: String)-> MPMediaQuery! {
        // 曲名で絞り込む
        let songNameFilter = MPMediaPropertyPredicate(
            value: song,
            forProperty: MPMediaItemPropertyTitle,
            comparisonType: MPMediaPredicateComparison.contains)
        // アルバム名で絞り込む
        let albumTitleFilter = MPMediaPropertyPredicate(
            value: albam,
            forProperty: MPMediaItemPropertyAlbumTitle,
            comparisonType: MPMediaPredicateComparison.equalTo)
        // アーティスト名で絞り込む
        let artistFilter = MPMediaPropertyPredicate(
            value: artist,
            forProperty: MPMediaItemPropertyArtist,
            comparisonType: MPMediaPredicateComparison.contains)
        
        //　3種のフィルタの結合
        let myFilterSet: Set<MPMediaPropertyPredicate> = [albumTitleFilter, songNameFilter,artistFilter]
        
        //クエリの作成
        let myQuery = MPMediaQuery(filterPredicates: myFilterSet)
        
        return myQuery
        
    }
}
