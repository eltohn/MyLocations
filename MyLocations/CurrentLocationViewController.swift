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
        label.numberOfLines = 0
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
        return button
    }()
    
    //MARK:- INSTANCES
    let locationManager = CLLocationManager()
    var location: CLLocation?
    
    var updatingLocation = false
    var lastLocationError: Error?
    
    //MARK:- REVERSE GEOCODING
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: Error?
    
    var timer: Timer?
    
    
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
            timer = Timer.scheduledTimer(timeInterval: 60,
                                         target: self,
                                         selector: #selector(didTimeOut),
                                         userInfo: nil,
                                         repeats: false)
        }
    }
    
    @objc func didTimeOut(){
        print("Time Out")
        if location == nil{
            stopLocationManager()
            lastLocationError = NSError(domain: "MyLocationsErrorDomain",
                                        code: 1,
                                        userInfo: nil)
            updateLabels()
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
            if let timer = timer{
                timer.invalidate()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print(newLocation)
        
        if newLocation.timestamp.timeIntervalSinceNow < -5{
            return
        }
        
        if newLocation.horizontalAccuracy < 0{
            return
        }
         
        // New section #1
        var distance = CLLocationDistance(Double.greatestFiniteMagnitude)
        if let location = location {
            distance = newLocation.distance(from: location)
        }
        // End of new section #1
        
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy{
            lastLocationError = nil
            location = newLocation
            
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy{
                print("we are done")
                stopLocationManager()
                // New section #2
                if distance > 0 {
                    performingReverseGeocoding = false
                }
                // End of new section #2
            }
            updateLabels()
            
            //MARK:- REVERSE GEOCODING IN ACTION
            if !performingReverseGeocoding{
                performingReverseGeocoding = true
                
                geocoder.reverseGeocodeLocation(newLocation) { placemarks, error in
                    self.lastGeocodingError = error
                    if error == nil, let places = placemarks, !places.isEmpty {
                        self.placemark = places.last!
                    } else {
                        self.placemark = nil
                    }
                    self.performingReverseGeocoding = false
                    self.updateLabels()
                }
            }
            
        }else if distance < 1{
            let timeInterval = newLocation.timestamp.timeIntervalSince(location!.timestamp)
            if timeInterval > 10 {
                print("*** Force done!")
                stopLocationManager()
                updateLabels()
            }
        }
    }
    
    func updateLabels() {
        if let location = location {
            latInfoLabel.text = String(format: "%.8f",location.coordinate.latitude)
            longInfoLabel.text = String(format: "%.8f",location.coordinate.longitude)
            tagLocationButton.isHidden = false
            messageLabel.isHidden = true
            
            if let placemark = placemark {
                addressLabel.text = String.placemarkToString(from: placemark)
            } else if performingReverseGeocoding {
                addressLabel.text = "Searching for Address..."
            } else if lastGeocodingError != nil {
                addressLabel.text = "Error Finding Address"
            } else {
                addressLabel.text = "No Address Found"
            }
            
        } else {
            let statusMessage: String
            if let error = lastLocationError as NSError? {
                if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
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
        configureGetButon()
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
        tagLocationButton.addTarget(self, action: #selector(tagLocationTapped), for: .touchUpInside)
    }
    
    @objc func getLocationPressed(){
        
        let authStatus = locationManager.authorizationStatus
        
        if authStatus == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }else if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        if updatingLocation {
          stopLocationManager()
        } else {
          location = nil
          lastLocationError = nil
          startLocationManager()
        }
        updateLabels()
    }
    
    @objc func tagLocationTapped(){
        let vc = LocationDetailsViewController()
        vc.coordinate = location!.coordinate
        vc.placemark = placemark
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureGetButon(){
        if updatingLocation{
            getMyLocationButton.setTitle("Stop", for: .normal)
        }else{
            getMyLocationButton.setTitle("Get My Location", for: .normal)
        }
    }
}
