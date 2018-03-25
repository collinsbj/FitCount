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

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var incorrectInfoLabel: UILabel!
    
    var userData: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incorrectInfoLabel.isHidden = true
        userNameTextField.delegate = self
        passWordTextField.delegate = self
        userNameTextField.returnKeyType = UIReturnKeyType.next
        passWordTextField.returnKeyType = UIReturnKeyType.send
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            
            nextField.becomeFirstResponder()
            
        } else {
            
            textField.resignFirstResponder()
            signIn()
            
            return true;
            
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signInSegue" {
            let dashboardVC = segue.destination as! DashboardController
            dashboardVC.userName = String(describing: self.userData["userName"])
        }
    }
    
    func signIn() {
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

    @IBAction func signInButtonPressed(_ sender: UIButton) {
        signIn()
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "signUpSegue", sender: self)

    }
    
}

