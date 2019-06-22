//
//  ViewController.swift
//  tv-zaichkin
//
//  Created by WSR on 6/21/19.
//  Copyright © 2019 WSR. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var tempValue: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var windStrength: UILabel!
    @IBOutlet weak var weatherPicture: UIImageView!
    
    var city = "Moscow"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadWeatherInfo()
    }
    
    @IBAction func weatherOnmap(_ sender: Any) {
    }
    
    func loadWeatherInfo()  {
        if let cityStr: String = UserDefaults.standard.string(forKey: "City") {
            city = cityStr
        }
        
        let apiKey = "1e936ee21707e2a418e98dca00877357"
        let url = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&apiKey=\(apiKey)&units=metric"
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                //если запрос выполнен успешно, то разбираем ответ и вытаскиваем нужные данные
                let json = JSON(value)
                print("JSON: \(json)")
                
                self.cityName.text = self.city
                self.tempValue.text = json["main"]["temp"].stringValue + " °C"
                self.weatherDescription.text = json["weather"][0]["main"].stringValue
                self.windStrength.text = json["wind"]["speed"].stringValue
                
                let icon = json["weather"][0]["icon"].stringValue
                let imageStr = "http://openweathermap.org/img/w/" + icon + ".png"
                let imageUrl = URL(string: imageStr)
                if let data = try? Data(contentsOf: imageUrl!) {
                    self.weatherPicture.image = UIImage(data: data)
                }
                
            case .failure(let error):
                print(error)
            }
            
            
            
            
            
        }
        
        
        
    }
}


