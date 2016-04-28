//
//  Constants.swift
//  Weather
//
//  Created by Casey Lyman on 4/17/16.
//  Copyright © 2016 bearcode. All rights reserved.
//

import Foundation

let APPID_KEY = "&APPID=d2b4d0832bb56cc344eab971b405d3da"
let URL_BASE_ID = "http://api.openweathermap.org/data/2.5/weather?id="
let URL_BASE_CITY = "http://api.openweathermap.org/data/2.5/weather?q="
let URL_UNITS_IMP = "&units=imperial"
let URL_UNITS_MET = "&units=metric"

let ALLOWED_CHAR = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890=?/.&:"

let LOC_UPDATE_NOTIF_KEY = "com.locationUpdateFromUserLocation"

typealias DownloadComplete = () -> ()
