//
//  DashboardController.swift
//  FitCountv2
//
//  Created by BJ Collins on 3/23/18.
//  Copyright © 2018 BJ Collins. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DashboardController: UIViewController, NewFitCountData {

    @IBOutlet weak var fitCountLabel: UILabel!
    @IBOutlet weak var usersNameLabel: UILabel!
    
    var userData: JSON = []
    
    var userName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getUserData()  {
        let newURL = "https://fitcountbe.herokuapp.com/" + userName
        Alamofire.request(newURL, method: .get).responseJSON {
            response in
            if response.result.isSuccess {                
                self.userData = JSON(response.result.value!)
                
                self.fitCountLabel.text = String(describing: self.userData["totalFitCount"])
                self.usersNameLabel.text = String(describing: self.userData["firstName"]) + " " + String(describing: self.userData["lastName"])
                
            }
            else {
                print("connection failure: \(String(describing: response.result.error))")
                self.fitCountLabel.text = "Connection Issues"
            }
        }

    }
    
    func setNewFitCountData(data: String) {
        fitCountLabel.text = data
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "workoutSegue" {
            let workoutVC = segue.destination as! WorkoutController
            
            workoutVC.userName = userName
            workoutVC.userFitCount = String(describing: userData["totalFitCount"])
            workoutVC.userGymLat = Double(String(describing: userData["gymLat"]))!
            workoutVC.userGymLon = Double(String(describing: userData["gymLon"]))!
            workoutVC.userGymName = userData["gymName"].string!
            workoutVC.delegate = self
        }
    }
    
    @IBAction func checkInButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "workoutSegue", sender: self)
    }
    
    @IBAction func lougoutButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
