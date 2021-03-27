//
//  WeatherViewController.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/26/21.
//

import UIKit

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
    
    var temperature: Double!
    var windSpeed: Double!
    var uvIndex: Double!
    var sunset: Int!
    var sunrise: Int!
    var windDegree: Int!
    var pressure: Int!
    var type: String!
    
    // MARK: - View LyfeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Functions
    private func configureView() {
        var tempDegree: String = "--"
        var windSpeedText: String = "--"
        var uvIndexText: String = "--"
        var sunsetText: String = "--"
        var sunriseText: String = "--"
        var windDegreeText: String = "--"
        var pressureText: String = "--"
        var weatherType: String = "--"
        
        if let temperature = temperature {
            tempDegree = convertTemp(temp: temperature, from: .kelvin, to: .celsius)
        }
        if let windSpeed = windSpeed {
            windSpeedText = "\(windSpeed) meter/s"
        }
        if let uvIndex = uvIndex {
            uvIndexText = "\(uvIndex)"
        }
        if let sunset = sunset {
            sunsetText = fromIntToDate(time: sunset)
        }
        if let sunrise = sunrise {
            sunriseText = fromIntToDate(time: sunrise)
        }
        if let windDegree = windDegree {
            windDegreeText = "\(Double(windDegree).direction)"
        }
        if let pressure = pressure {
            pressureText = "\(pressure) hPa"
        }
        if let type = type {
            weatherType = type
        }
        
        self.weatherType.text = weatherType
        weatherDegree.text = tempDegree
        windLabel.text = windSpeedText
        uvLabel.text = uvIndexText
        sunsetLabel.text = sunsetText
        sunriseLabel.text = sunriseText
        wDirectionLabel.text = windDegreeText
        pressureLabel.text = pressureText
    }
    
    // MARK: - IBActions
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
