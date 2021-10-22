//
//  ViewController.swift
//  MyLocations
//
//  Created by Elbek Shaykulov on 24/09/21.
//

import UIKit
import SnapKit
import CoreLocation

class CurrentLocationViewController: UIViewController {
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "(Message Label)"
        return label
    }()
    
    private let latitudeLabel: UILabel = {
        let label = UILabel()
        label.text = "Latitude:"
        return label
    }()
    
    private let longtitudeLabel: UILabel = {
        let label = UILabel()
        label.text = "Longtitude:"
        return label
    }()
    
    private let latInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Latitude goes here"
        return label
    }()
    
    private let longInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Longtitude goes here"
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "(Address goes here)"
        return label
    }()
    
    private let tagLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tag Location", for: .normal)
        //        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let getMyLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get My Location", for: .normal)
        //        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    //MARK:- INSTANCES
    let locationManager = CLLocationManager()
    var location: CLLocation?
    
    var updatingLocation = false
    var lastLocationError: Error?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setuoSnapkitCons()
        updateLabels()
    }
}

//MARK:-  CLLocation methods
extension CurrentLocationViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        
        if (error as NSError).code == CLError.locationUnknown.rawValue{
            return
        }
        lastLocationError = error
        stopLocationManager()
        updateLabels()
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last
        print(newLocation)
        location = newLocation
        updateLabels()
    }
    
    func updateLabels() {
        if let location = location {
            latInfoLabel.text = String(format: "%.8f",location.coordinate.latitude)
            longInfoLabel.text = String(format: "%.8f",location.coordinate.longitude)
            tagLocationButton.isHidden = false
            messageLabel.isHidden = true
        } else {
            let statusMessage: String
            if let error = lastLocationError as NSError? {
                if error.domain == kCLErrorDomain && error.code ==
                    CLError.denied.rawValue {
                    statusMessage = "Location Services Disabled"
                } else {
                    statusMessage = "Error Getting Location"
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disabled"
            } else if updatingLocation {
                statusMessage = "Searching..."
            } else {
                statusMessage = "Tap 'Get My Location' to Start"
            }
            messageLabel.text = statusMessage
        }
    }
    
    private func showLocationServicesDeniedAlert(){
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}


//MARK:- UI constraints
extension CurrentLocationViewController{
    
    private func setuoSnapkitCons(){
        view.addSubview(messageLabel)
        
        view.addSubview(latitudeLabel)
        view.addSubview(longtitudeLabel)
        view.addSubview(latInfoLabel)
        view.addSubview(longInfoLabel)
        view.addSubview(addressLabel)
        
        view.addSubview(tagLocationButton)
        view.addSubview(getMyLocationButton)
        
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        latitudeLabel.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        latInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.left.equalTo(longInfoLabel.snp.left)
        }
        
        longtitudeLabel.snp.makeConstraints { make in
            make.top.equalTo(latitudeLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        longInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(latitudeLabel.snp.bottom).offset(20)
            make.left.equalTo(longtitudeLabel.snp.right).offset(40)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(longtitudeLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        tagLocationButton.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        
        getMyLocationButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.centerX.equalToSuperview()
        }
        
        //MARK:- TARGETS
        getMyLocationButton.addTarget(self, action: #selector(getLocationPressed), for: .touchUpInside)
    }
    
    @objc func getLocationPressed(){
        
        let authStatus = locationManager.authorizationStatus
        
        if authStatus == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }else if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        startLocationManager()
        updateLabels()
    }
    
    
    
}
