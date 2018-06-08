import UIKit
import MapKit
import RealmSwift

class newViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //シングルトン（予め創っておいた共有のインスタンス）呼び出し(ここで色々起こる)
    let sharedLocationManager :sharedLocation = sharedLocation.Manager
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableViewのデリゲート、データソースになる
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // ピンを落とす
        for location in sharedLocationManager.locations {
            sharedLocationManager.dropPin(mapView: mapView,at: location)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Private methods
    
    //（スタートボタンをタップ）
    @IBAction func startButtonDidTap(_ sender: AnyObject,sharedLocationManager :sharedLocation) {
        sharedLocationManager.toggleLocationUpdate(startButton: startButton, tableView: tableView)
    }
    
    //（クリアボタンをタップ）
    @IBAction func clearButtonDidTap(_ sender: AnyObject,sharedLocationManager :sharedLocation) {
        sharedLocationManager.deleteAllLocations()
        sharedLocationManager.locations = sharedLocationManager.loadStoredLocations()
        sharedLocationManager.removeAllAnnotations(mapView:mapView)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return sharedLocationManager.loadStoredLocations().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        let location = sharedLocationManager.loadStoredLocations()[indexPath.row]
        cell.textLabel?.text = "\(location.latitude),\(location.longitude)"
        cell.detailTextLabel?.text = location.createdAt.description
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - MKMapView delegate
    
    func mapView(_ mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "annotationIdentifier"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.animatesDrop = true
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    
}


