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
    
    //MARK:- INSTANCE VARIABLES
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setuoSnapkitCons()
    }

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
//            make.width.equalToSuperview().multipliedBy(0.2)
        }
        
        latInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.left.equalTo(longInfoLabel.snp.left)
        }
        
        longtitudeLabel.snp.makeConstraints { make in
            make.top.equalTo(latitudeLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
//            make.width.equalToSuperview().multipliedBy(0.2)
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
    
    
}

extension CurrentLocationViewController: CLLocationManagerDelegate{
     
    @objc func getLocationPressed(){
        let authStatus = locationManager.authorizationStatus
        if authStatus == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print(newLocation)
    }
}
