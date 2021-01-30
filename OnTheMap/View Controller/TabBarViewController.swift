//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Ali Şahbaz on 27.01.2021.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func logoutButtonClicked(_ sender: Any) {
        UdacityClient.sharedinstance().logout { (error) in
            guard error == nil else {
                self.showAlert(message: error!.localizedDescription)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        if let mapViewController = self.viewControllers?.first as? StudentLocationMapViewController {
            mapViewController.fetchStudentLocation()
        }
        
        if let tableViewController = self.viewControllers?[1] as? StudentLocationTableViewController {
            tableViewController.fetchStudentLocation()
        }
    }
}
