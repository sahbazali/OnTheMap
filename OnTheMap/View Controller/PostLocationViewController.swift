//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Ali Şahbaz on 27.01.2021.
//

import Foundation
import UIKit
import MapKit

class PostLocationViewController: UIViewController {
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var adress : String = ""
    var url: String = ""
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLocationOnMap()
    }
    
    func showLocationOnMap() {
        let annotation = MKPointAnnotation()
        let latitute = location!.coordinate.latitude
        let longitude = location!.coordinate.longitude
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitute, longitude: longitude)
        annotation.title = adress
        map.addAnnotation(annotation)
        map.setRegion(MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000), animated: true)
    }
    
    @IBAction func postLocationClicked(_ sender: Any) {
        loadingIndicator.startAnimating()
        UdacityClient.sharedinstance().postStudentLocation(mapString: adress, mediaUrl: url, latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude) { (error) in
            self.loadingIndicator.stopAnimating()
            guard error == nil else {
                self.showAlert(message: "Can't post student location")
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
