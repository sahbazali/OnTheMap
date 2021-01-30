//
//  StudentLocationMapViewController.swift
//  OnTheMap
//
//  Created by Ali Şahbaz on 26.01.2021.
//

import Foundation
import UIKit
import MapKit

class StudentLocationMapViewController : UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var studentLocationList : [StudentLocationModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStudentLocation()
    }
    
    func fetchStudentLocation() {
        loadingIndicator.startAnimating()
        UdacityClient.sharedinstance().getStudentLocations(limit: 100, order: "-updatedAt") { (result) in
            self.loadingIndicator.stopAnimating()
            switch result {
            case .success(let response):
                self.studentLocationList = response.results
                self.showStudentLocations()
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    func showStudentLocations() {
        var annotations = [MKPointAnnotation]()
        
        for studentLocation in studentLocationList {
            let lat = CLLocationDegrees(studentLocation.latitude)
            let long = CLLocationDegrees(studentLocation.longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
            annotation.subtitle = studentLocation.mediaURL
            
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
}

extension StudentLocationMapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: "\(toOpen)")!)
            }
        }
    }
}
