//
//  CitiesWeather.swift
//  iWeather
//
//  Created by Jinna,Kavya on 12/7/14.
//  Copyright (c) 2014 jinnaKavya. All rights reserved.
//

import UIKit

class CitiesWeather: UIViewController,UIPickerViewDataSource,UIPickerViewAccessibilityDelegate{

    @IBOutlet weak var locationViewer: UITextView!
    
    @IBOutlet weak var tempViewer: UITextView!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var pickerComponent: UIPickerView!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */
    
    let pickerData = [
        ["NY-New York","OH-Columbus","CA-San Francisco","WA-Olympia","TX-Austin","IL-Chicago","FL-Tallahassee","ID-Boise"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerComponent.delegate=self
        pickerComponent.dataSource=self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabel(){
        let size = pickerData[0][pickerComponent.selectedRowInComponent(0)]
      //  let topping = pickerData[1][pickerComponent.selectedRowInComponent(1)]
     //   pizzaLabel.text = "Pizza: " + size + " " + topping
        println(size)
        var keywords=size.componentsSeparatedByString("-")
        var state:String=keywords[0]
        var city:String=keywords[1]
         locationViewer.text="\(city): \(state)"
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
        
        
        
    }
    
    //MARK -Delgates and DataSource
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[component][row]
    }

}
