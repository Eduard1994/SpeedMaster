//
//  WeatherViewController.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/26/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var weatherDegree: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var uvLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var wDirectionLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    
    var emptyData = "--"
    var location: CLLocation?
    
    var weather: Weather! {
        willSet {
            if let temperature = newValue.current?.temp {
                weatherDegree.text = convertTemp(temp: temperature, from: .kelvin, to: .celsius)
            }
            if let windSpeed = newValue.current?.windSpeed {
                windLabel.text = "\(windSpeed) m/s"
            }
            if let uvIndex = newValue.current?.uvi {
                uvLabel.text = "\(uvIndex)"
            }
            if let sunset = newValue.current?.sunset {
                sunsetLabel.text = fromIntToDate(time: sunset)
            }
            if let sunrise = newValue.current?.sunrise {
                sunriseLabel.text = fromIntToDate(time: sunrise)
            }
            if let windDegree = newValue.current?.windDeg {
                wDirectionLabel.text = "\(Double(windDegree).direction)"
            }
            if let pressure = newValue.current?.pressure {
                pressureLabel.text = "\(pressure) hPa"
            }
            if let type = newValue.current?.weather?.last?.weatherDescription?.rawValue {
                weatherType.text = type.uppercased()
            }
        }
    }
    
    // MARK: - View LyfeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Functions
    private func configureView() {
        guard let location = location else {
            weatherDegree.text = emptyData
            windLabel.text = emptyData
            uvLabel.text = emptyData
            sunsetLabel.text = emptyData
            sunriseLabel.text = emptyData
            wDirectionLabel.text = emptyData
            pressureLabel.text = emptyData
            weatherType.text = emptyData
            return
        }
        getWeather(from: location)
    }
    
    private func getWeather(from location: CLLocation) {
        DispatchQueue.global().async {
            Service().getWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { (weather, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        ErrorHandling.showError(message: error.localizedDescription, controller: self)
                    }
                    return
                }
                
                if let weather = weather {
                    print("Here")
                    print(weather)
                    DispatchQueue.main.async {
                        self.weather = weather
                    }
                }
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
