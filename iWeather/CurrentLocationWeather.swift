//
//  CurrentLocationWeather.swift
//  iWeather
//
//  Created by Jinna,Kavya on 12/6/14.
//  Copyright (c) 2014 jinnaKavya. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationWeather: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var locationViewer: UITextView!
    
    @IBOutlet weak var tempViewer: UITextView!
   
    @IBOutlet weak var farenTemp: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func findMyLocation(sender: AnyObject) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            locationViewer.text="\(locality): \(administrativeArea)"
            println("State:\(administrativeArea)")
            println("City:\(locality)")
            let state=administrativeArea
            let city=locality
            var newcity:AnyObject!
            newcity=city.stringByReplacingOccurrencesOfString(" ", withString: "_", options: nil, range: nil)
            println("newcity\(newcity)")
            var url = NSURL(string:"http://api.wunderground.com/api/56968011acc3e3eb/conditions/q/\(state)/\(newcity).json")
            var data = NSData.dataWithContentsOfURL(url, options: NSDataReadingOptions.DataReadingUncached, error: nil)
            var str = NSString(data:data, encoding:NSUTF8StringEncoding)
            var json:AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
            var weatherInfo:AnyObject! = json.objectForKey("current_observation")
            var currentTemp: AnyObject! = weatherInfo.objectForKey("temperature_string")
            var humidity:AnyObject! = weatherInfo.objectForKey("relative_humidity")
            var wind:AnyObject! = weatherInfo.objectForKey("wind_kph")
            var fareTemp:AnyObject!=weatherInfo.objectForKey("temp_f")
            var celTemp:AnyObject!=weatherInfo.objectForKey("temp_c")
            var icon:AnyObject!=weatherInfo.objectForKey("icon_url")
            
            var url1:NSURL = NSURL.URLWithString("\(icon)")
            var data1:NSData = NSData.dataWithContentsOfURL(url1, options: nil, error: nil)
            weatherIcon.image = UIImage(data:data1)
            
            tempViewer.text="Temperature: \(currentTemp)\nHumidity: \(humidity)\nWind: \(wind)mph\n"
          //  farenTemp.text="\(fareTemp)"
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }

   
}
