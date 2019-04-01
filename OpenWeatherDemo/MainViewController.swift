//
//  ViewController.swift
//  OpenWeatherDemo
//
//  Created by user on 1/4/19.
//  Copyright © 2019 appguru. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var CurrentWeather: UILabel!
    @IBOutlet weak var CurrentTemp: UILabel!
    @IBOutlet weak var WeatherImage: UIImageView!
    @IBOutlet weak var LocationTime: UILabel!
    @IBOutlet weak var TableList: UITableView!
    
    let APIKEY = "fdc80cfc6caa69092d632ca9de1ded6f"
    var dateList = [String]()
    var minList = [Float]()
    var maxList = [Float]()
    var Currentdate = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RequestURL()
        CurrentWeather.isHidden = true
        CurrentTemp.isHidden = true
        WeatherImage.isHidden = true
        LocationTime.isHidden = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        Currentdate = dateFormatter.string(from: NSDate() as Date)
    }
    
    func RequestURL() {
        
        let jsonURL = "http://api.openweathermap.org/data/2.5/forecast?q=singapore&mode=json&APPID=\(APIKEY)"
        guard let url = URL(string: jsonURL) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    return
                }
                
                guard let data = data else {return}
                
                do {
                    let decoder = JSONDecoder()
                    let weather = try decoder.decode(WeatherList.self, from: data)
                    print(weather.list)
                    
                    self.dateList = weather.list.map({$0.dt_txt!})
                    self.minList = weather.list.map({$0.main.temp_min!})
                    self.maxList = weather.list.map({$0.main.temp_max!})
                    
                    self.TableList.reloadData()
                    
                    let temp = weather.list[0].main.temp
                    let location = weather.city.name
                    let Currentweather = weather.list[0].weather[0].description
                    let weatherID = weather.list[0].weather[0].id
                    let weatherLogo = self.weatherImage(id: weatherID!)
                    
                    self.LocationTime.text = "\(self.Currentdate), \(location!)"
                    self.CurrentTemp.text = "\(self.convertToCelsius(Kelvin: temp!)) °C"
                    self.CurrentWeather.text = Currentweather
                    
                    self.SettingWeatherImage(WeatherText: weatherLogo)
                    
                    self.CurrentWeather.isHidden = false
                    self.CurrentTemp.isHidden = false
                    self.WeatherImage.isHidden = false
                    self.LocationTime.isHidden = false
                    
                    
                }catch let jsonError {
                    print(jsonError)
                }
            }
            }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableList.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherTableViewCell
        
        cell.DateInfo.text = "Date: \(dateList[indexPath.row])"
        cell.minInfo.text = "MinTemp: \(String(convertToCelsius(Kelvin: minList[indexPath.row])))°C"
        cell.maxInfo.text = "MaxTemp: \(String(convertToCelsius(Kelvin: maxList[indexPath.row])))°C"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func convertToCelsius(Kelvin: Float) -> Int {
        return Int(Kelvin - 273.15)
    }
    
    func weatherImage(id: Int) -> String {
        switch (id) {
        case 200...531 :
            return "raining"
        case 600...622 :
            return "snowing"
        case 800...802 :
            return "sunny"
        case 803...804 :
            return "cloud"
        default:
            return "nothing"
        }
    }
    
    func SettingWeatherImage(WeatherText: String) {
        
        if WeatherText == "raining" {
            self.WeatherImage.image = UIImage(named: "rain by Freepik")
        }
        else if WeatherText == "sunny" {
            self.WeatherImage.image = UIImage(named: "cloudy by iconixar")
        }
        else if WeatherText == "snowing" {
            self.WeatherImage.image = UIImage(named: "stormy by Freepik")
        }
        else if WeatherText == "cloud" {
            self.WeatherImage.image = UIImage(named: "clouds by Freepik")
        }
        else {
            self.WeatherImage.image = UIImage(named: "no-stopping by Those Icons")
        }
    }


}


class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var DateInfo: UILabel!
    @IBOutlet weak var minInfo: UILabel!
    @IBOutlet weak var maxInfo: UILabel!
    
}
