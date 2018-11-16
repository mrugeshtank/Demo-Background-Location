//
//  ViewController.swift
//  Demo Background Location
//
//  Created by DeathStroke on 16/11/18.
//  Copyright © 2018 DeathStroke. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var btnStartStop: UIButton!
    var locationManager: CLLocationManager!
    var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd MMM, yyyy HH:mm:ss"
        return df
    }()
    var lastTimeStamp: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btnStartStop.layer.cornerRadius = 3.0
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        //This will indicating that app is using location in background mode
        locationManager.showsBackgroundLocationIndicator = true
        //This will not stop updating location automatically, thought this is not recommanded, app will use more energy
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.requestAlwaysAuthorization()
    }
    
    @IBAction func btnSelected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            locationManager.startUpdatingLocation()
        }
        else {
            if CLLocationManager.authorizationStatus() == .authorizedAlways && CLLocationManager.locationServicesEnabled() {
                locationManager.stopUpdatingLocation()
            }
            else {
                let alert = UIAlertController(title: "Error", message: "App has no access to location", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            let lat = lastLocation.coordinate.latitude
            let long = lastLocation.coordinate.longitude
            let printableStr = String(format: "Latitude:%.6f, Longitude:%.6f", lat, long)
            var dateStr = ""
            
            let date = lastLocation.timestamp
            dateStr = dateFormatter.string(from: date)
            print(dateStr + " " + printableStr)
            if let lastTimeStamp = lastTimeStamp {
                let interval = lastTimeStamp.timeIntervalSinceNow
                if interval > 1800 {
                    //update to DB
                }
            }
            self.lastTimeStamp = date
        }
    }
}


