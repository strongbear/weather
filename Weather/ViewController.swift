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
    @IBOutlet weak var fcDay1Img: UIImageView!
    @IBOutlet weak var fcDay1MaxLbl: UILabel!
    @IBOutlet weak var fcDay1MinLbl: UILabel!
    @IBOutlet weak var fcDay2Img: UIImageView!
    @IBOutlet weak var fcDay2MaxLbl: UILabel!
    @IBOutlet weak var fcDay2MinLbl: UILabel!
    @IBOutlet weak var fcDay3Img: UIImageView!
    @IBOutlet weak var fcDay3MaxLbl: UILabel!
    @IBOutlet weak var fcDay3MinLbl: UILabel!
    @IBOutlet weak var fcDay4Img: UIImageView!
    @IBOutlet weak var fcDay4MaxLbl: UILabel!
    @IBOutlet weak var fcDay4MinLbl: UILabel!
    
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
            for ndx in 0...3 {
                
                if let fcImage = self.localWeather.dailyForecast[ndx]["icon"] as? String {
                    if let maxT = self.localWeather.dailyForecast[ndx]["maxTemp"] as? Int {
                        if let minT = self.localWeather.dailyForecast[ndx]["minTemp"] as? Int {
                            if ndx == 0 {
                                self.fcDay1Img.image = UIImage(named: "\(fcImage)")
                                self.fcDay1MaxLbl.text = "\(maxT)"
                                self.fcDay1MinLbl.text = "\(minT)"
                            } else if ndx == 1 {
                                self.fcDay2Img.image = UIImage(named: "\(fcImage)")
                                self.fcDay2MaxLbl.text = "\(maxT)"
                                self.fcDay2MinLbl.text = "\(minT)"
                            } else if ndx == 2 {
                                self.fcDay3Img.image = UIImage(named: "\(fcImage)")
                                self.fcDay3MaxLbl.text = "\(maxT)"
                                self.fcDay3MinLbl.text = "\(minT)"
                            } else if ndx == 3 {
                                self.fcDay4Img.image = UIImage(named: "\(fcImage)")
                                self.fcDay4MaxLbl.text = "\(maxT)"
                                self.fcDay4MinLbl.text = "\(minT)"
                            }
                        }
                    }
                }
            }
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

