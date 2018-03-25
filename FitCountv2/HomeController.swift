//
//  ViewController.swift
//  FitCountv2
//
//  Created by BJ Collins on 3/23/18.
//  Copyright © 2018 BJ Collins. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var incorrectInfoLabel: UILabel!
    
    var userData: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incorrectInfoLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signInSegue" {
            let dashboardVC = segue.destination as! DashboardController
            dashboardVC.userName = String(describing: self.userData["userName"])
        }
    }

    @IBAction func signInButtonPressed(_ sender: UIButton) {
        let newURL = "https://fitcountbe.herokuapp.com/" + userNameTextField.text!
        Alamofire.request(newURL, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                self.userData = JSON(response.result.value!)
                
                if self.userNameTextField.text == String(describing: self.userData["userName"]) && self.passWordTextField.text == String(describing: self.userData["password"]) {
                    self.incorrectInfoLabel.isHidden = true
                    self.performSegue(withIdentifier: "signInSegue", sender: self)
                }
            }
            else {
                self.incorrectInfoLabel.isHidden = false
            }
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "signUpSegue", sender: self)

    }
    
}

