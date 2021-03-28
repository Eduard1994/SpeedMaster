//
//  MeasureViewController.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/22/21.
//

import UIKit

protocol UpdateUnit: class {
    func updatedUnit(unit: Unit)
}

class MeasureViewController: UIViewController {
    @IBOutlet weak var measureView: UIView!
    @IBOutlet weak var measureStackView: UIStackView!
    @IBOutlet var linedViews: [UIView]!
    @IBOutlet weak var okayButton: UIButton!
    
    // MARK: - Properties
    var unit: Unit = Unit.selected
    weak var delegate: UpdateUnit?
    
    // MARK: - Override properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
    
    // MARK: - View LyfeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Functions
    private func configureView() {
        measureView.cornerRadius(to: 24)
        okayButton.cornerRadius(to: 10)
        
        unit = .selected
        prepareUnits()
        
        linedViews.forEach { (view) in
            view.addLine(position: .LINE_POSITION_BOTTOM, color: .black, width: 1)
        }
    }
    
    private func prepareUnits() {
        switch unit {
        case .kilometersPerHour:
            setImagesForButton(tags: [100, 110, 120])
        case .milesPerHour:
            setImagesForButton(tags: [110, 100, 120])
        case .knots:
            setImagesForButton(tags: [120, 100, 110])
        default:
            break
        }
    }
    
    private func setImagesForButton(tags: [Int]) {
        for i in 1...2 {
            measureStackView.subviews.forEach { (view) in
                if let button = view.viewWithTag(tags[i]) as? UIButton {
                    button.setImage(nil, for: .normal)
                    button.setBackgroundImage(imageNamed("checkBackgroundBlack"), for: .normal)
                }
            }
        }
        measureStackView.subviews.forEach { (view) in
            if let button = view.viewWithTag(tags[0]) as? UIButton {
                button.setImage(imageNamed("check"), for: .normal)
                button.setBackgroundImage(imageNamed("checkBackgroundBlue"), for: .normal)
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func backButtonTapped(_ sender: Any) {
        pop(animated: true)
    }
    
    @IBAction func okayTapped(_ sender: Any) {
        print("Okay Tapped")
        delegate?.updatedUnit(unit: unit)
        pop(animated: true)
    }
    
    @IBAction func kmTapped(_ sender: Any) {
        setImagesForButton(tags: [100, 110, 120])
        unit = unit.kilometers
    }
    
    @IBAction func mphTapped(_ sender: Any) {
        setImagesForButton(tags: [110, 100, 120])
        unit = unit.miles
    }
    
    @IBAction func knotsTapped(_ sender: Any) {
        setImagesForButton(tags: [120, 100, 110])
        unit = unit.knots
    }
}
