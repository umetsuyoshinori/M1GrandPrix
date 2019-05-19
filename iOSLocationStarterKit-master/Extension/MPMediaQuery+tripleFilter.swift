import MapKit

var hogeKey: UInt8 = 0

extension MKAnnotation {
    var album: String? {
        get {
            guard let object = objc_getAssociatedObject(self, &hogeKey) as? String else {
                return nil
            }
            return object
        }
        set {
            objc_setAssociatedObject(self, &hogeKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var artist: String? {
        get {
            guard let object = objc_getAssociatedObject(self, &hogeKey) as? String else {
                return nil
            }
            return object
        }
        set {
            objc_setAssociatedObject(self, &hogeKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var artwork: Data? {
        get {
            guard let object = objc_getAssociatedObject(self, &hogeKey) as? Data else {
                return nil
            }
            return object
        }
        set {
            objc_setAssociatedObject(self, &hogeKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
