import Foundation
import MediaPlayer

extension MPMediaItem{
    /// 曲情報を再生画面に表示する
    func updateSongInformationUI(ArtistLabel:UILabel,AlbamLabel:UILabel,NameLabel:UILabel, imageView: UIImageView) {
        //ラベルに各情報を表示
        ArtistLabel.text = self.artist ?? "不明なアーティスト"
        AlbamLabel.text = self.albumTitle ?? "不明なアルバム"
        NameLabel.text = self.title ?? "不明な曲"
        
        // アートワーク表示
        if let artwork = self.artwork {
            let image = artwork.image(at: imageView.bounds.size)
            imageView.image = image
        }
        else {// アートワークがないとき
            imageView.image = nil
            imageView.backgroundColor = UIColor.gray
        }
    }
}
