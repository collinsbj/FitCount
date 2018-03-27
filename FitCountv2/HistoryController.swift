//
//  HistoryController.swift
//  FitCountv2
//
//  Created by BJ Collins on 3/23/18.
//  Copyright © 2018 BJ Collins. All rights reserved.
//

import UIKit

class HistoryController: UIViewController {
    
    @IBOutlet weak var dashboardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dashboardButton.layer.cornerRadius = 6
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func dashboardButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
