//
//  ViewController.swift
//  Weather
//
//  Created by Casey Lyman on 4/17/16.
//  Copyright © 2016 bearcode. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    var localWeather: LocalWeatherData!
    var userLoc: UserLocation!
//    var locationManager: CLLocationManager!
//    var currentLocation = CLLocation()
    
    @IBOutlet weak var localityLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var windLbl: UILabel!
    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var sunsetLbl: UILabel!
    @IBOutlet weak var condImg: UIImageView!
    @IBOutlet weak var humidLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLoc = UserLocation()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "actOnLocationUpdate", name: LOC_UPDATE_NOTIF_KEY, object: nil)
    }
    
    func actOnLocationUpdate() {
        if localWeather != nil {
            localWeather.setCity(userLoc.locality)
            localWeather.downloadLocalWeather { () -> () in
                self.updateUI()
            }
            localWeather.downloadLocalWeatherForcast{ () -> () in
                self.updateUI()
            }
        }
    }
    
    func updateUI() {
        self.localityLbl.text = self.userLoc.locality
        let tempStr = "\(self.localWeather.temperature) \u{00B0}F"
        self.tempLbl.text = tempStr
        let windString = "\(self.localWeather.windDirection) @ \(self.localWeather.windSpeed) mph"
        self.windLbl.text = windString
        self.sunriseLbl.text = self.localWeather.sunrise
        self.sunsetLbl.text = self.localWeather.sunset
        self.humidLbl.text = self.localWeather.humidity
        if let image = UIImage(named: "\(self.localWeather.icon)") {
            self.condImg.image = image
        }
        if self.localWeather.dailyForecast.count > 0 {
            print("Ready for forecast UI")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        
        userLoc.getCurrentLocation { () -> () in
            print("\(self.userLoc.currentLocation.coordinate)")
            self.localWeather = LocalWeatherData(locationByCityName: self.userLoc.locality)
            self.localWeather.downloadLocalWeather { () -> () in
                print("Inside download weather completion")
                self.updateUI()
            }
            self.localWeather.downloadLocalWeatherForcast { () -> () in
                print("Inside download weather forecast")
            }

        }
        
        
        
        
    }


}

