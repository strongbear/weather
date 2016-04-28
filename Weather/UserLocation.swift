//
//  UserLocation.swift
//  Weather
//
//  Created by Casey Lyman on 4/17/16.
//  Copyright © 2016 bearcode. All rights reserved.
//

import Foundation
import CoreLocation
import AddressBookUI

class UserLocation: NSObject, CLLocationManagerDelegate {

    private var _locationManager: CLLocationManager!
    private var _currentLocation = CLLocation()
    private var _locality: String!
    private var _country: String!
    private var _address: [String]!
    
    var locationManager: CLLocationManager {
        return _locationManager
    }
    
    var currentLocation: CLLocation {
        return _currentLocation
    }
    
    var locality: String {
        if _locality == nil {
            return "Locality Unknown"
        }
        return _locality
    }
    
    var country: String {
        if _country == nil {
            return "Country Unknown"
        }
        return _country
    }
    
    var address: [String] {
        if _address == nil {
            return ["Address Unknown"]
        }
        return _address
    }

//    override init() {
//        super.init()
//        self.getCurrentLocation { () -> () in
//            self.updateUI()
//        }
//        
//    }
//    
//    func updateUI() {
//        print("Made it here too")
//    }
//    
    func locationAuthorizationStatus(){
        if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse {
            self._locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func getCurrentLocation(completed: DownloadComplete){
        _locationManager = CLLocationManager()
        locationAuthorizationStatus()
        _locationManager.delegate = self
        _locationManager.distanceFilter = kCLLocationAccuracyThreeKilometers
        _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        _locationManager.startUpdatingLocation()
        completed()
//        if _locationManager.location != nil {
//            _currentLocation = _locationManager.location!
//            getGeocodeInfo { () -> () in
//                print("Made it here")
//                completed()
//            }
//        }
        
     }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _currentLocation = locations[0]
        print("\(_currentLocation.coordinate)")
        getGeocodeInfo { () -> () in
            print("Updated location")
            NSNotificationCenter.defaultCenter().postNotificationName(LOC_UPDATE_NOTIF_KEY, object: self)
        }
    }
    
    func getGeocodeInfo(completed: DownloadComplete) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(_currentLocation) { (placemark, error) -> Void in
            if error != nil {
                print("Error: \(error?.localizedDescription)")
                return
            }
            if placemark?.count > 0 {
                let pm = placemark![0] as CLPlacemark

                self._locality = pm.locality
                self._country = pm.country
                if let formattedAdd = pm.addressDictionary?["FormattedAddressLines"] as? [String] {
                    print("\(formattedAdd)")
                    self._address = formattedAdd
                }
            }
            completed()
        }
    }

    
}
