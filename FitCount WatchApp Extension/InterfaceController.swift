//
//  InterfaceController.swift
//  FitCount WatchApp Extension
//
//  Created by BJ Collins on 3/26/18.
//  Copyright © 2018 BJ Collins. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var fitCountWatchLabel: WKInterfaceLabel!
    
    var session:WCSession!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
        
        if WCSession.isSupported() {
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        fitCountWatchLabel.setText(String(describing: message["points"]!))
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }

}
