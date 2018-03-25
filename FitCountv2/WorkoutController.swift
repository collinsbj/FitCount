//
//  WorkoutController.swift
//  FitCountv2
//
//  Created by BJ Collins on 3/23/18.
//  Copyright © 2018 BJ Collins. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON

protocol NewFitCountData {
    func setNewFitCountData(data: String)
}

class WorkoutController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentFitCountLabel: UILabel!
    @IBOutlet weak  var fitCountNumberLabel: UILabel!
    @IBOutlet weak var startWorkoutButton: UIButton!
    @IBOutlet weak var finishWorkoutButton: UIButton!
    
    var delegate: NewFitCountData?
    
    var currentPoints  = 0
    
    var userName: String = ""
    var userFitCount: String = ""
    
    var newPoints: String = ""
    
    var heartRate = 0 {
        didSet {
            if heartRate >= 100 {
                currentPoints += 1
                fitCountNumberLabel.text = String(currentPoints)
            }
        }
    }
    
    var locationManager: CLLocationManager!
    var timer: Timer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fitCountNumberLabel.text = String(currentPoints)
        
        currentFitCountLabel.isHidden = true
        fitCountNumberLabel.isHidden = true
        finishWorkoutButton.isHidden = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last as! CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }
    
    @objc func saveMockHeartRateData() {
        heartRate = Int(arc4random_uniform(100) + 50)
    }
    
    func startMockHeartRateData() {
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(saveMockHeartRateData),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stopMockHeartRateData() {
        self.timer?.invalidate()
    }
    
    func sendData() {
        newPoints = String(Int(currentPoints) + Int(userFitCount)!)
        let myParams: Parameters = ["totalFitCount": newPoints]
        let newURL: String = "https://fitcountbe.herokuapp.com/" + userName
        
        Alamofire.request(newURL, method: .put, parameters: myParams, encoding: JSONEncoding.default)
        
    }

    
    @IBAction func startWorkoutButton(_ sender: UIButton) {
        mapView.isHidden = true
        startWorkoutButton.isHidden = true
        currentFitCountLabel.isHidden = false
        fitCountNumberLabel.isHidden = false
        finishWorkoutButton.isHidden = false
        
        startMockHeartRateData()
    }
    
    @IBAction func finishWorkoutButton(_ sender: UIButton) {
        stopMockHeartRateData()
        sendData()
        delegate?.setNewFitCountData(data: newPoints )
        self.dismiss(animated: true, completion: nil)
    }
    
}
