//
//  LocalWeatherData.swift
//  Weather
//
//  Created by Casey Lyman on 4/17/16.
//  Copyright © 2016 bearcode. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Alamofire

class LocalWeatherData: NSObject {
    
    private var _cityName: String!
    private var _cityId: String!
    private var _temperature: String!
    private var _windSpeed: String!
    private var _windDirection: String!
    private var _humidity: String!
    private var _sunrise: String!
    private var _sunset: String!
    private var _location: CLLocation!
    private var _weatherUrl: String!
    private var _weatherForcastUrl: String!
    private var _icon: String!
    private var _dailyForecast = [Dictionary<String, AnyObject>]()
    
    var dailyForecast: [Dictionary<String, AnyObject>] {
        return _dailyForecast
    }
    
    var location: CLLocation {
        get {
            return _location
        }
        set {
            _location = newValue
        }
    }
    
    var cityName: String {
        if _cityName == nil {
            return "unknown"
        }
        return _cityName
    }
    
    var cityId: String {
        if _cityId == nil {
            return "unknown"
        }
        return _cityId
    }
    
    var temperature: String {
        if _temperature == nil {
            return "?"
        }
        return _temperature
    }
    
    var windSpeed: String {
        if _windSpeed == nil {
            return "?"
        }
        return _windSpeed
    }
    
    var windDirection: String {
        if _windDirection == nil {
            return "0 deg"
        }
        return _windDirection
    }
    
    var humidity: String {
        if _humidity == nil {
            return "?"
        }
        return _humidity
    }
    
    var sunrise: String {
        if _sunrise == nil {
            return "0:00"
        }
        return _sunrise
    }
    
    var sunset: String {
        if _sunset == nil {
            return "0:00"
        }
        return _sunset
    }
    
    var icon: String {
        if _icon == nil {
            return "01d"
        }
        return _icon        
    }
    
    init(locationByCityName: String) {
        self._cityName = locationByCityName
        
        _weatherUrl = "\(URL_BASE_CITY)\(_cityName)\(URL_UNITS_IMP)\(APPID_KEY)"
        _weatherForcastUrl = "\(URL_FORECAST_CITY)\(_cityName)\(URL_UNITS_IMP)\(URL_FIVEDAY_CNT)\(APPID_KEY)"
//        _weatherUrl = "\(URL_BASE)2172797\(APPID_KEY)"
//        _weatherUrl = "\(URL_BASE)\(_cityName)"
        
    }
    
    func setCity(cityName: String) {
        self._cityName = cityName
        _weatherUrl = "\(URL_BASE_CITY)\(_cityName)\(URL_UNITS_IMP)\(APPID_KEY)"
        _weatherForcastUrl = "\(URL_FORECAST_CITY)\(_cityName)\(URL_UNITS_IMP)\(URL_FIVEDAY_CNT)\(APPID_KEY)"
    }
    
    func downloadLocalWeather(completed: DownloadComplete){
        //let allowChar = NSCharacterSet(charactersInString: ALLOWED_CHAR)
        let urlString = _weatherUrl.stringByAddingPercentEncodingWithAllowedCharacters(ALLOWED_CHAR_NSCS)!
        let url = NSURL(string: urlString)!
        Alamofire.request(.GET, url).responseJSON { response -> Void in
            let result = response.result
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = .MediumStyle
            dateFormatter.timeZone = NSTimeZone()
            dateFormatter.dateStyle = .NoStyle

            if let dict = result.value as? Dictionary<String,AnyObject> {
                if let name = dict["name"] as? String {
                    print("\(name)")
                }
                if let main = dict["main"] as? Dictionary<String,AnyObject> {
                    if let temp = main["temp"] as? Int {
                        self._temperature = "\(temp)"
                        print("\(temp)")
                    }
                    if let humid = main["humidity"] as? Int {
                        self._humidity = "\(humid)"
                    }
                }
                if let wind = dict["wind"] as? Dictionary<String, AnyObject> {
                    if let speed = wind["speed"] as? Int {
                        self._windSpeed = "\(speed)"
                        print("\(speed)")
                    }
                    if let deg = wind["deg"] as? Double {
                        if deg > 348.75 || deg <= 11.25 {
                            self._windDirection = "N"
                        } else if deg > 11.25 && deg <= 33.75 {
                            self._windDirection = "NNE"
                        } else if deg > 33.75 && deg <= 56.25 {
                            self._windDirection = "NE"
                        } else if deg > 56.25 && deg <= 78.75 {
                            self._windDirection =  "ENE"
                        } else if deg > 78.75 && deg <= 101.25 {
                            self._windDirection = "E"
                        } else if deg > 101.25 && deg <= 123.75 {
                            self._windDirection = "ESE"
                        } else if deg > 123.75 && deg <= 146.25 {
                            self._windDirection = "SE"
                        } else if deg > 146.25 && deg <= 168.75 {
                            self._windDirection = "SSE"
                        } else if deg > 168.75 && deg <= 191.25 {
                            self._windDirection = "S"
                        } else if deg > 191.25 && deg <= 213.75 {
                            self._windDirection = "SSW"
                        } else if deg > 213.75 && deg <= 236.25 {
                            self._windDirection = "SW"
                        } else if deg > 236.25 && deg <= 258.75 {
                            self._windDirection = "WSW"
                        } else if deg > 258.75 && deg <= 281.25 {
                            self._windDirection = "W"
                        } else if deg > 281.25 && deg <= 303.75 {
                            self._windDirection = "WNW"
                        } else if deg > 303.75 && deg <= 326.25 {
                            self._windDirection = "NW"
                        } else if deg > 326.25 && deg <= 348.75 {
                            self._windDirection = "NNW"
                        }
                        //self._windDirection = "\(deg)"
                        print("\(deg)")
                    }
                }
                if let sys = dict["sys"] as? Dictionary<String,AnyObject> {
                    if let sunrise = sys["sunrise"] as? Double {
                        let timeResult = NSDate(timeIntervalSince1970: sunrise)
                        let localTime = dateFormatter.stringFromDate(timeResult)
                        self._sunrise = localTime
                        print("\(localTime)")
                    }
                    if let sunset = sys["sunset"] as? Double {
                        let timeResult = NSDate(timeIntervalSince1970: sunset)
                        let localTime = dateFormatter.stringFromDate(timeResult)
                        self._sunset = localTime
                        print("\(localTime)")                        
                    }
                }
                if let weather = dict["weather"] as? [Dictionary<String,AnyObject>] {
                    if let main = weather[0]["main"] as? String {
                        print("\(main)")
                    }
                    if let desc = weather[0]["description"] as? String {
                        print("\(desc)")
                    }
                    if let icon = weather[0]["icon"] as? String {
                        self._icon = icon
                    }
                }
            }
            completed()
        }
    }
    
    func downloadLocalWeatherForcast(completed: DownloadComplete){
        let urlString = _weatherForcastUrl.stringByAddingPercentEncodingWithAllowedCharacters(ALLOWED_CHAR_NSCS)!
        let url = NSURL(string: urlString)!
        Alamofire.request(.GET, url).responseJSON { response -> Void in
            let result = response.result
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = .NoStyle
            dateFormatter.timeZone = NSTimeZone()
            dateFormatter.dateStyle = .ShortStyle
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let cnt = dict["cnt"] as? Int {
                    if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                        for ndx in 0...cnt-1 {
                            if let dt = list[ndx]["dt"] as? Double {
                                let timeResult = NSDate(timeIntervalSince1970: dt)
                                let dateResult = dateFormatter.stringFromDate(timeResult)
                                if ndx+1 > self._dailyForecast.count {
                                    self._dailyForecast.append(["date" : dateResult])
                                } else {
                                    self._dailyForecast[ndx]["date"] = dateResult
                                }
                                print("\(dateResult)")
                            }
                            if let temp = list[ndx]["temp"] as? Dictionary<String,Int> {
                                let minT = temp["min"]
                                let maxT = temp["max"]
                                self._dailyForecast[ndx]["minTemp"] = minT
                                self._dailyForecast[ndx]["maxTemp"] = maxT
                            }
                            if let weather = list[ndx]["weather"] as? [Dictionary<String,AnyObject>] {
                                if let icon = weather[0]["icon"] as? String{
                                    let newIcon = icon.stringByReplacingOccurrencesOfString("n", withString: "d")
                                    self._dailyForecast[ndx]["icon"] = newIcon
                                }
                            }
                        
                        }
                    }
                }
            }
        }
        completed()
    }
}
