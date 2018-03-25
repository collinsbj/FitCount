//
//  SignUpController.swift
//  FitCountv2
//
//  Created by BJ Collins on 3/23/18.
//  Copyright © 2018 BJ Collins. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var gymNameTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        retypePasswordTextField.delegate = self
        gymNameTextField.delegate = self
        
        firstNameTextField.returnKeyType = UIReturnKeyType.next
        lastNameTextField.returnKeyType = UIReturnKeyType.next
        userNameTextField.returnKeyType = UIReturnKeyType.next
        emailTextField.returnKeyType = UIReturnKeyType.next
        passwordTextField.returnKeyType = UIReturnKeyType.next
        retypePasswordTextField.returnKeyType = UIReturnKeyType.next
        gymNameTextField.returnKeyType = UIReturnKeyType.send
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            
            nextField.becomeFirstResponder()
            
        } else {
            
            textField.resignFirstResponder()
            signUp()
            
            return true;
            
        }
        return false
    }
    
    
    func signUp() {
        
        let userParams: [String:Any] = ["userName": userNameTextField.text!, "password": passwordTextField.text!, "totalFitCount": 0, "gymLat": "40.586194", "gymLon": "-105.043533", "gymName": gymNameTextField.text!, "firstName": firstNameTextField.text!, "lastName": lastNameTextField.text!, "email": emailTextField.text!, "fitCountHistory": [:]]
        
        let newURL = "https://fitcountbe.herokuapp.com/" + userNameTextField.text!
        
        if passwordTextField.text == retypePasswordTextField.text {
            
            
            
            Alamofire.request(newURL, method: .get).responseJSON {
                response in
                if response.result.isSuccess {
                    self.errorLabel.text = "Username is taken.  Please try another one."
                    self.errorLabel.isHidden = false
                }
                else {
                    Alamofire.request("https://fitcountbe.herokuapp.com/", method: .post, parameters: userParams, encoding: JSONEncoding.default)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            self.errorLabel.text = "Password fields do not match."
            self.errorLabel.isHidden = false
        }
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        signUp()
    }
    
}
