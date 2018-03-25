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

final class UserGymAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        super.init()
    }
}

class WorkoutController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentFitCountLabel: UILabel!
    @IBOutlet weak  var fitCountNumberLabel: UILabel!
    @IBOutlet weak var startWorkoutButton: UIButton!
    @IBOutlet weak var finishWorkoutButton: UIButton!
    @IBOutlet weak var tooFarFromGymWarning: UILabel!
    
    var delegate: NewFitCountData?
    var currentPoints  = 0
    var userName: String = ""
    var userFitCount: String = ""
    var userGymLon = 0.000
    var userGymLat = 0.000
    var userGymName = ""
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
    var currentLocation: CLLocationCoordinate2D?
    var userGymCoordinate: CLLocationCoordinate2D?
    var distanceFromGym: Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        userGymCoordinate = CLLocationCoordinate2D(latitude: userGymLat, longitude: userGymLon)
        let gymAnnotation = UserGymAnnotation(coordinate: userGymCoordinate!, title: userGymName, subtitle: "Your gym!")
        mapView.addAnnotation(gymAnnotation)
        
        fitCountNumberLabel.text = String(currentPoints)
        
        currentFitCountLabel.isHidden = true
        fitCountNumberLabel.isHidden = true
        finishWorkoutButton.isHidden = true
        tooFarFromGymWarning.isHidden = true
        
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
        let location = locations.last!
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        currentLocation = (manager.location?.coordinate)!
        distanceFromGym = CLLocation(latitude: (currentLocation?.latitude)!, longitude: (currentLocation?.longitude)!).distance(from: CLLocation(latitude: (userGymCoordinate?.latitude)!, longitude: (userGymCoordinate?.longitude)! )) * 0.00062137
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
        
        if Int(distanceFromGym!) < 1 {
        mapView.isHidden = true
        startWorkoutButton.isHidden = true
        currentFitCountLabel.isHidden = false
        fitCountNumberLabel.isHidden = false
        finishWorkoutButton.isHidden = false
        
        startMockHeartRateData()
        } else {
            tooFarFromGymWarning.isHidden = false
        }
    }
    
    @IBAction func finishWorkoutButton(_ sender: UIButton) {
        stopMockHeartRateData()
        sendData()
        delegate?.setNewFitCountData(data: newPoints )
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension WorkoutController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let gymAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            gymAnnotationView.animatesWhenAdded = true
            gymAnnotationView.titleVisibility = .adaptive
            gymAnnotationView.subtitleVisibility = .adaptive
            
            return gymAnnotationView
        }
        return nil
    }
}
