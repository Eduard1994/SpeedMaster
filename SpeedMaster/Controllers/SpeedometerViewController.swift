//
//  SpeedometerViewController.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import CoreLocation
import UIKit

class SpeedometerViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var allowLocationView: UIView!
    @IBOutlet weak var resetButton: UIButton!
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private let service = Service()
    private var weather: Weather!
    
    var timer = Timer()
    
    var started: Bool = false {
        willSet {
            resetButton.isHidden = !newValue
            resetButton.isEnabled = newValue
        }
    }
    
    var speed: Double = 0.0 {
        willSet {
            average.append(newValue)
            speedometerView.progress = Settings.unit.calculateSpeed(for: newValue)
        }
    }
    
    var counter: Double = 0.0 {
        willSet {
            speedometerView.counter = newValue
        }
    }
    
    var average: [Double] = [] {
        willSet {
            speedometerView.average = newValue
        }
    }
    
    var currentDistance: Double = 0.0 {
        willSet {
            speedometerView.currentDistance = newValue
        }
    }
    
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    /// Total Data
    var currentDate: Date = Date()
    var maxSpeed: Double!
    var minSpeed: Double!
    var avrSpeed: Double!
    var windSpeed: Double!
    var duration: Double!
    var distance: Double!
    var allSpeeds: [Double]!
    
    lazy var speedometerView: SpeedometerView = {
        let view = SpeedometerView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    lazy var weatherVC: WeatherViewController = {
        let vc = WeatherViewController.instantiate(from: .Weather, with: WeatherViewController.typeName)
        return vc
    }()
    
    // MARK: - Override properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
    
    // MARK: - View LyfeCicle
    override func viewDidLoad() {
        locationManager.delegate = self
        super.viewDidLoad()
        configureView()
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Functions
    private func configureView() {
        view.addSubview(speedometerView)
        resetButton.cornerRadius(to: 20)
        resetButton.addBorder(width: 2.0, color: .mainWhite)
        resetButton.isHidden = !started
        resetButton.isEnabled = started
        
        setupConstraints()
        prepareLocation()
    }
    
    private func setupConstraints() {
        speedometerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        speedometerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        speedometerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
        speedometerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -187).isActive = true
    }
    
    private func prepareLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("Not determined")
            allowLocationView.isHidden = false
            speedometerView.isHidden = true
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("restircted")
            allowLocationView.isHidden = false
            speedometerView.isHidden = true
            locationManager.stopUpdatingLocation()
        case .denied:
            print("denied")
            allowLocationView.isHidden = false
            speedometerView.isHidden = true
            locationManager.stopUpdatingLocation()
        case .authorizedWhenInUse, .authorizedAlways:
            print("authorized")
            allowLocationView.isHidden = true
            speedometerView.isHidden = false
            startLocationManager()
        @unknown default:
            fatalError("has been detected an unsupported authorization status of the CLLocationManager instance")
        }
    }
    
    private func updateWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.service.getWeather(latitude: latitude, longitude: longitude) { (weather, error) in
                if let error = error {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        ErrorHandling.showError(message: error.localizedDescription, controller: self)
                        self.locationManager.stopUpdatingLocation()
                    }
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if let weather = weather {
                        let temp = weather.current?.temp
                        self.weather = weather
                        self.speedometerView.updateWeather(temp: temp)
                    }
                }
            }
        }
    }
    
    private func update(with speed: Double, at latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        if started {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.speed = speed
                print(Settings.unit.rawValue)
                print(self.speedometerView.progress)
            }
        }
    }
    
    private func updateDistance(locations: [CLLocation]) {
        if started {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if self.startLocation == nil {
                    self.startLocation = locations.first
                } else if let location = locations.last {
                    self.currentDistance += self.lastLocation.distance(from: location)
                    print("Traveled Distance:",  self.currentDistance)
                    print("Straight Distance:", self.startLocation.distance(from: locations.last!))
                }
                
                self.lastLocation = locations.last
            }
        }
    }
    
    private func update(with locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let speed = location.speed
        
        print("Speed = \(location.speed), Latitude = \(location.coordinate.latitude), Longitude = \(location.coordinate.longitude)")
        
        updateDistance(locations: locations)
        update(with: speed, at: latitude, longitude: longitude)
        updateWeather(latitude: latitude, longitude: longitude)
    }
    
    private func startLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    private func start() {
        if started {
            print("Started")
            reset()
            startLocationManager()
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        } else {
            stop()
        }
    }
    
    private func stop() {
        print("Stopped")
        print("Total:/nDate = \(Date()), Max Speed = ")
        self.timer.invalidate()
    }
    
    private func reset() {
        counter = 0.0
        average = []
        currentDistance = 0.0
        speed = 0.0
        startLocation = nil
        lastLocation = nil
    }
    
    // MARK: - Objc Functions
    @objc func updateTimer() {
        counter += 0.1
    }
    
    // MARK: - IBActions
    @IBAction func playButtonTapped(_ sender: Any) {
        guard let sender = sender as? UIButton else { return }
        sender.isSelected = !sender.isSelected
        sender.setImage(sender.isSelected ? imageNamed("stopImage") : imageNamed("playImage"), for: .normal)
        prepareLocation()
        started = sender.isSelected
        start()
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        reset()
    }
}

// MARK: - CLLocationManager Delegate
extension SpeedometerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
        prepareLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.update(with: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if (error as? CLError)?.code == .denied {
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }
}

// MARK: - Speedometer Delegate
extension SpeedometerViewController: SpeedometerDelegate {
    func speedChanged() {
        print("Speed Changed")
    }
    
    func tappedWeather() {
        print("Tapped weather")
        if let weather = weather {
            weatherVC.temperature = weather.current?.temp
            weatherVC.windSpeed = weather.current?.windSpeed
            weatherVC.uvIndex = weather.current?.uvi
            weatherVC.sunset = weather.current?.sunset
            weatherVC.sunrise = weather.current?.sunrise
            weatherVC.windDegree = weather.current?.windDeg
            weatherVC.pressure = weather.current?.pressure
            weatherVC.type = weather.current?.weather?.last?.main?.rawValue
        }
        presentPopover(weatherVC, animated: true)
    }
}
