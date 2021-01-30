//
//  StudentLocationTableViewController.swift
//  OnTheMap
//
//  Created by Ali Şahbaz on 26.01.2021.
//

import Foundation
import UIKit

class StudentLocationTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
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
        tableView.reloadData()
    }
}

extension StudentLocationTableViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        studentLocationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentLocationCell")!
        
        let studentLocation = studentLocationList[indexPath.row]
        cell.textLabel?.text = studentLocation.firstName + " " + studentLocation.lastName
        cell.detailTextLabel?.text = studentLocation.mediaURL
        cell.imageView?.image = UIImage(named:"icon_pin")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlStr = studentLocationList[indexPath.row].mediaURL
        if let url = URL(string: "\(urlStr)") {
            UIApplication.shared.open(url)
        }

    }
    
    
}
