//
//  SpeedometerView.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/26/21.
//

import UIKit

protocol SpeedometerDelegate {
    func speedChanged()
    func tappedWeather()
}

class SpeedometerView: UIView {

    // MARK: - Properties
    var delegate: SpeedometerDelegate?
    
    let circularSlider = CircularProgress(frame: .zero)
    
    let speedLabel = UILabel()
    let speedMetric = UILabel()
    
    let weatherButton = UIButton()
    
    let distanceLabel = UILabel()
    let distance = UILabel()
    
    let averageSpeedLabel = UILabel()
    let averageSpeed = UILabel()
    
    let durationLabel = UILabel()
    let duration = UILabel()
    
    var progress: Double = 0.0 {
        willSet {
            circularSlider.angle = newValue < 0 ? 0.0 : newValue
            speedLabel.text = "\(Int(newValue))"
        }
    }
    
    var unit: Unit = Unit.selected {
        didSet {
            speedMetric.text = unit.rawValue
        }
    }
    
    var counter: Double = 0.0 {
        willSet {
            durationLabel.text = newValue.duration()
        }
    }
    
    var average: [Double] = [] {
        willSet {
            let speedTotal = newValue.sum()
            print("Speed Total = \(speedTotal)")
            let speedAverage = newValue.average()
            print("Speed Average = \(speedAverage)")
            averageSpeedLabel.text = unit.calculateAverageSpeed(for: speedAverage)
        }
    }
    
    var currentDistance: Double = 0.0 {
        willSet {
            distanceLabel.text = unit.calculateDistance(for: newValue)
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(unitChanged), name: unitChangedNotification, object: nil)
        
        backgroundColor = .mainBlack
        cornerRadius(to: 25)
        
        addSubviews(speedLabel, speedMetric, circularSlider, weatherButton, distanceLabel, distance, averageSpeedLabel, averageSpeed, durationLabel, duration)
        
        circularSlider.trackColor = .mainDark
        circularSlider.startAngle = 90
        circularSlider.progressThickness = 0.34
        circularSlider.trackThickness = 0.35
        circularSlider.clockwise = true
        circularSlider.roundedCorners = true
        circularSlider.gradientRotateSpeed = 2
        circularSlider.glowMode = .forward
        circularSlider.glowAmount = 0.9
        circularSlider.set(colors: .mainYellow)
        circularSlider.center = center
        circularSlider.angle = progress
        
        speedLabel.textColor = .mainWhite
        speedLabel.contentMode = .center
        speedLabel.font = .sfProDisplay(ofSize: 90, style: .heavyItalic)
        speedLabel.text = "\(Int(progress))"
        
        speedMetric.textColor = .mainDarkGray
        speedMetric.contentMode = .center
        speedMetric.font = .sfProDisplay(ofSize: 12, style: .medium)
        speedMetric.text = unit.rawValue
        
        weatherButton.backgroundColor = .mainBlue
        weatherButton.cornerRadius(to: 20)
        weatherButton.setTitleColor(.mainWhite, for: .normal)
        let attributedString = NSAttributedString(string: "--", attributes: [NSAttributedString.Key.font: UIFont.sfProText(ofSize: 16, style: .semibold), NSAttributedString.Key.foregroundColor: UIColor.mainWhite])
        weatherButton.setAttributedTitle(attributedString, for: .normal)
        weatherButton.addTarget(self, action: #selector(weatherTapped), for: .touchUpInside)
        
        distanceLabel.textColor = .mainWhite
        distanceLabel.contentMode = .center
        distanceLabel.font = .sfProDisplay(ofSize: 18, style: .blackItalic)
        distanceLabel.text = "--"
        
        distance.textColor = .mainDarkGray
        distance.font = .sfProDisplay(ofSize: 12, style: .medium)
        distance.text = "Distance"
        
        averageSpeedLabel.textColor = .mainWhite
        averageSpeedLabel.contentMode = .center
        averageSpeedLabel.font = .sfProDisplay(ofSize: 18, style: .blackItalic)
        averageSpeedLabel.text = "--"
        
        averageSpeed.textColor = .mainDarkGray
        averageSpeed.font = .sfProDisplay(ofSize: 12, style: .medium)
        averageSpeed.text = "Avr. speed"
        
        durationLabel.textColor = .mainWhite
        durationLabel.contentMode = .center
        durationLabel.font = .sfProDisplay(ofSize: 18, style: .blackItalic)
        durationLabel.text = "--"
        
        duration.textColor = .mainDarkGray
        duration.font = .sfProDisplay(ofSize: 12, style: .medium)
        duration.text = "Duration"
        
        circularSlider.translatesAutoresizingMaskIntoConstraints = false
        speedLabel.translatesAutoresizingMaskIntoConstraints = false
        speedMetric.translatesAutoresizingMaskIntoConstraints = false
        weatherButton.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distance.translatesAutoresizingMaskIntoConstraints = false
        averageSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        averageSpeed.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        duration.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            weatherButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            weatherButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            weatherButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 65),
            weatherButton.heightAnchor.constraint(equalToConstant: 40),
            
            circularSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            circularSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            circularSlider.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            circularSlider.bottomAnchor.constraint(equalTo: averageSpeedLabel.topAnchor, constant: 0),
            
            speedLabel.centerXAnchor.constraint(equalTo: circularSlider.centerXAnchor),
            speedLabel.centerYAnchor.constraint(equalTo: circularSlider.centerYAnchor),
            speedLabel.topAnchor.constraint(equalTo: topAnchor, constant: 135),
            
            speedMetric.centerXAnchor.constraint(equalTo: speedLabel.centerXAnchor),
            speedMetric.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: 5),
            
            distanceLabel.centerXAnchor.constraint(equalTo: distance.centerXAnchor),
            distanceLabel.bottomAnchor.constraint(equalTo: distance.topAnchor, constant: 0),
            
            distance.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 45),
            distance.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -37),
            
            averageSpeedLabel.centerXAnchor.constraint(equalTo: averageSpeed.centerXAnchor),
            averageSpeedLabel.bottomAnchor.constraint(equalTo: averageSpeed.topAnchor, constant: 0),
            
            averageSpeed.centerXAnchor.constraint(equalTo: centerXAnchor),
            averageSpeed.centerYAnchor.constraint(equalTo: distance.centerYAnchor),
            
            durationLabel.centerXAnchor.constraint(equalTo: duration.centerXAnchor),
            durationLabel.bottomAnchor.constraint(equalTo: duration.topAnchor, constant: 0),
            
            duration.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -45),
            duration.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -37)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    @objc func unitChanged() {
        unit = Settings.unit
    }
    
    @objc func updateSpeed() {
        delegate?.speedChanged()
    }
    
    @objc func weatherTapped() {
        delegate?.tappedWeather()
    }
    
    public func updateWeather(temp: Double?) {
        guard let temp = temp else {
            let attributedString = NSAttributedString(string: "--", attributes: [NSAttributedString.Key.font: UIFont.sfProText(ofSize: 16, style: .semibold)])
            weatherButton.setAttributedTitle(attributedString, for: .normal)
            return
        }
        
        let celsius = convertTemp(temp: temp, from: .kelvin, to: .celsius)
        let attributedString = NSAttributedString(string: "\(celsius)", attributes: [NSAttributedString.Key.font: UIFont.sfProText(ofSize: 16, style: .semibold), NSAttributedString.Key.foregroundColor: UIColor.mainWhite])
        weatherButton.setAttributedTitle(attributedString, for: .normal)
    }
}
