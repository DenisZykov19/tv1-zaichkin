//
//  MapViewController.swift
//  tv-zaichkin
//
//  Created by WSR on 6/22/19.
//  Copyright © 2019 WSR. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON


class MapViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var speedWindLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    //Функция для отображения региона на карте и функция для textField
    func showCityOnMap(lat: Double, lon: Double) {
        let regionRadius: CLLocationDistance = 10000
        let coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        seachCity(city: cityTextField.text!)
        return true
    }
  //Функция отображения информации о конкретном городе
    func seachCity(city: String) {
        cityTextField.placeholder = "Введите город"
        let apiKey = "1e936ee21707e2a418e98dca00877357"
        let url = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&apiKey=\(apiKey)&units=metric"
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                //если запрос выполнен успешно, то разбираем ответ и вытаскиваем нужные данные
                let json = JSON(value)
                print("JSON: \(json)")
                
                let lon = json["coord"]["lon"].doubleValue
                let lat = json["coord"]["lat"].doubleValue
                self.showCityOnMap(lat: lat, lon: lon)

                self.weatherView.isHidden = false
                self.tempLabel.text = json["main"]["temp"].stringValue + " °C"
                self.cityLabel.text = json["name"].stringValue
                UserDefaults.standard.set(self.cityLabel.text, forKey:"City")
                self.speedWindLabel.text = "Скорость ветра: " + json["wind"]["speed"].stringValue
                
                let icon = json["weather"][0]["icon"].stringValue
                let imageStr = "http://openweathermap.org/img/w/" + icon + ".png"
                let imageUrl = URL(string: imageStr)
                if let data = try? Data(contentsOf: imageUrl!) {
                    self.weatherImageView.image = UIImage(data: data)
                }
                
            case .failure(let error):
                print(error)
                self.cityTextField.text = ""
                self.cityTextField.placeholder = "Город не найден"
            }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}
