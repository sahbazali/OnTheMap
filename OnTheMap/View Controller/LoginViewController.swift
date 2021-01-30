//
//  ViewController.swift
//  OnTheMap
//
//  Created by Ali Şahbaz on 25.01.2021.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        UdacityClient.sharedinstance().login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (error) in
            guard error == nil else {
            self.showAlert(message: error!.localizedDescription)
                return
            }
            self.getUserInfo()
        }
    }
    @IBAction func signUpButtonClicked(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com")!)
        
    }
    
    func getUserInfo() {
        UdacityClient.sharedinstance().getUserInfo(userID: UserManager.shared.user.userID) { (result) in
            switch result {
            case .success(let response):
                UserManager.shared.user.firstName = response.firstName
                UserManager.shared.user.lastName = response.lastName
                self.performSegue(withIdentifier: "loginSuccess", sender: self)
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
}

