//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Ali Şahbaz on 27.01.2021.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController : UIViewController {
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var linkedinTextField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var adress : String = ""
    var url: String = ""
    var location: CLLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLocationOnMap" {
            if let controller = segue.destination as? PostLocationViewController{
                controller.adress = adress
                controller.location = location
                controller.url = url
            }
        }
    }
    
    @IBAction func findLocationClicked(_ sender: Any) {
        guard let address = addressTextField.text, let url = linkedinTextField.text else {
            self.showAlert(message: "Please fill informations")
            return
        }
        
        if address.trimmingCharacters(in: .whitespaces).isEmpty || url.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showAlert(message: "Please fill informations")
            return
        }
        
        let geoCoder = CLGeocoder()
        loadingIndicator.startAnimating()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            self.loadingIndicator.stopAnimating()
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                self.showAlert(message: "Can't find location")
                return
            }
            self.adress = address
            self.url = url
            self.location = location
            self.performSegue(withIdentifier: "showLocationOnMap", sender: self)
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
