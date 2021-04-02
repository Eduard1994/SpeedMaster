//
//  Slide.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/20/21.
//

import UIKit

class Slide: UIView {
    // MARK: - IBOutlets
    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var notNowButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locTimerImageView: UIImageView!
    @IBOutlet weak var imageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var imageViewTop: NSLayoutConstraint!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var blackViewLeading: NSLayoutConstraint! // 15 by default
    @IBOutlet weak var blackViewTrailing: NSLayoutConstraint! // 15 by default
    @IBOutlet weak var blackViewBottom: NSLayoutConstraint! // 15 by default
    @IBOutlet weak var upgradeLabel: UILabel!
    @IBOutlet weak var speedImage: UIImageView!
    @IBOutlet weak var barImage: UIImageView!
    @IBOutlet weak var startFreeLabel: UILabel!
    @IBOutlet weak var gpsLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var privacyEulaStackView: UIStackView!
    @IBOutlet weak var privacyLabel: UILabel!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var eulaButton: UIButton!
    @IBOutlet weak var tryFreeButton: UIButton!
    @IBOutlet weak var startMonthlyView: UIView!
    @IBOutlet weak var startMonthlyButton: UIButton!
    @IBOutlet weak var startMonthlySecondButton: UIButton!
    @IBOutlet weak var proceedWithBasic: UIButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint! // default 123
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint! // default 19
    @IBOutlet weak var fromBlackToYellow: NSLayoutConstraint! // default 82
    @IBOutlet weak var fromTryFreeToProceed: NSLayoutConstraint! //default 34
    @IBOutlet weak var fromUpgradeToTop: NSLayoutConstraint! // default 76
    @IBOutlet weak var fromNotNowToTop: NSLayoutConstraint! // default 35
    
    // MARK: - Properties
    static var slides: [Slide] {
        let slide1: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.yellowView.cornerRadius(to: 25)
        slide1.blackView.cornerRadius(to: 25)
        slide1.upgradeLabel.isHidden = true
        slide1.speedImage.isHidden = true
        slide1.barImage.isHidden = true
        slide1.startFreeLabel.isHidden = true
        slide1.proceedWithBasic.isHidden = true
        slide1.proceedWithBasic.isEnabled = false
        slide1.tryFreeButton.isHidden = true
        slide1.tryFreeButton.isEnabled = false
        slide1.startMonthlyButton.isEnabled = false
        slide1.startMonthlySecondButton.isEnabled = false
        slide1.startMonthlyView.isHidden = true
        slide1.yellowView.isHidden = false
        slide1.imageView.isHidden = false
        slide1.locTimerImageView.isHidden = false
        slide1.imageView.image = imageNamed("onboardingRunning")
        slide1.locTimerImageView.image = imageNamed("onboardingLocation")
        slide1.gpsLabel.isHidden = false
        slide1.trackLabel.isHidden = false
        slide1.privacyEulaStackView.isHidden = true
        slide1.privacyButton.isEnabled = false
        slide1.eulaButton.isEnabled = false
//        slide1.gpsLabel.text = "First"
//        slide1.trackLabel.text = "Label"
        
        switch type {
        case .iPhone5_5S_5C_SE:
            slide1.topConstraint.constant = 123
            slide1.bottomConstraint.constant = 19
            slide1.fromBlackToYellow.constant = 82
            slide1.fromTryFreeToProceed.constant = 34
            slide1.fromUpgradeToTop.constant = 76
            slide1.fromNotNowToTop.constant = 35
        case .iPhone6_6S_7_8_SE2:
            slide1.topConstraint.constant = 123
            slide1.bottomConstraint.constant = 19
            slide1.fromBlackToYellow.constant = 82
            slide1.fromTryFreeToProceed.constant = 34
            slide1.fromUpgradeToTop.constant = 76
            slide1.fromNotNowToTop.constant = 35
        case .iPhone6Plus_6SPlus_7Plus_8Plus:
            slide1.topConstraint.constant = 123
            slide1.bottomConstraint.constant = 19
            slide1.fromBlackToYellow.constant = 110
            slide1.fromTryFreeToProceed.constant = 71
            slide1.fromUpgradeToTop.constant = 76
            slide1.fromNotNowToTop.constant = 35
        case .iPhone12Mini:
            slide1.topConstraint.constant = 148
            slide1.bottomConstraint.constant = 30
            slide1.fromBlackToYellow.constant = 100
            slide1.fromTryFreeToProceed.constant = 72
            slide1.fromUpgradeToTop.constant = 76
            slide1.fromNotNowToTop.constant = 35
        case .iPhoneX_XS_11Pro:
            slide1.topConstraint.constant = 170
            slide1.bottomConstraint.constant = 30
            slide1.fromBlackToYellow.constant = 110
            slide1.fromTryFreeToProceed.constant = 72
            slide1.fromUpgradeToTop.constant = 85
            slide1.fromNotNowToTop.constant = 40
        case .iPhone12_12Pro:
            slide1.topConstraint.constant = 200
            slide1.bottomConstraint.constant = 30
            slide1.fromBlackToYellow.constant = 118
            slide1.fromTryFreeToProceed.constant = 67
            slide1.fromUpgradeToTop.constant = 90
            slide1.fromNotNowToTop.constant = 45
        case .iPhoneXR_XSMax_11_11ProMax:
            slide1.topConstraint.constant = 185
            slide1.bottomConstraint.constant = 30
            slide1.fromBlackToYellow.constant = 185
            slide1.fromTryFreeToProceed.constant = 68
            slide1.fromUpgradeToTop.constant = 90
            slide1.fromNotNowToTop.constant = 45
        case .iPhone12ProMax:
            slide1.topConstraint.constant = 200
            slide1.bottomConstraint.constant = 30
            slide1.fromBlackToYellow.constant = 200
            slide1.fromTryFreeToProceed.constant = 69
            slide1.fromUpgradeToTop.constant = 90
            slide1.fromNotNowToTop.constant = 45
        default:
            break
        }
        
        let slide2: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.yellowView.cornerRadius(to: 25)
        slide2.blackView.cornerRadius(to: 25)
        slide2.upgradeLabel.isHidden = true
        slide2.speedImage.isHidden = true
        slide2.barImage.isHidden = true
        slide2.startFreeLabel.isHidden = true
        slide2.proceedWithBasic.isHidden = true
        slide2.proceedWithBasic.isEnabled = false
        slide2.tryFreeButton.isHidden = true
        slide2.tryFreeButton.isEnabled = false
        slide2.startMonthlyButton.isEnabled = false
        slide2.startMonthlySecondButton.isEnabled = false
        slide2.startMonthlyView.isHidden = true
        slide2.yellowView.isHidden = false
        slide2.imageView.isHidden = false
        slide2.locTimerImageView.isHidden = false
        slide2.imageView.image = imageNamed("onboardingHistory")
        slide2.locTimerImageView.image = imageNamed("onboardingTimer")
        slide2.gpsLabel.isHidden = false
        slide2.trackLabel.isHidden = false
        slide2.privacyEulaStackView.isHidden = true
        slide2.privacyButton.isEnabled = false
        slide2.eulaButton.isEnabled = false
//        slide2.gpsLabel.text = "Second"
//        slide2.trackLabel.text = "Label"
        
        switch type {
        case .iPhone5_5S_5C_SE:
            slide2.topConstraint.constant = 123
            slide2.bottomConstraint.constant = 19
            slide2.fromBlackToYellow.constant = 82
            slide2.fromTryFreeToProceed.constant = 34
        case .iPhone6_6S_7_8_SE2:
            slide2.topConstraint.constant = 123
            slide2.bottomConstraint.constant = 19
            slide2.fromBlackToYellow.constant = 82
            slide2.fromTryFreeToProceed.constant = 34
        case .iPhone6Plus_6SPlus_7Plus_8Plus:
            slide2.topConstraint.constant = 123
            slide2.bottomConstraint.constant = 19
            slide2.fromBlackToYellow.constant = 110
            slide2.fromTryFreeToProceed.constant = 71
        case .iPhone12Mini:
            slide2.topConstraint.constant = 148
            slide2.bottomConstraint.constant = 30
            slide2.fromBlackToYellow.constant = 100
            slide2.fromTryFreeToProceed.constant = 72
        case .iPhoneX_XS_11Pro:
            slide2.topConstraint.constant = 170
            slide2.bottomConstraint.constant = 30
            slide2.fromBlackToYellow.constant = 110
            slide2.fromTryFreeToProceed.constant = 72
            slide2.fromUpgradeToTop.constant = 85
            slide2.fromNotNowToTop.constant = 40
        case .iPhone12_12Pro:
            slide2.topConstraint.constant = 200
            slide2.bottomConstraint.constant = 30
            slide2.fromBlackToYellow.constant = 118
            slide2.fromTryFreeToProceed.constant = 67
            slide2.fromUpgradeToTop.constant = 90
            slide2.fromNotNowToTop.constant = 45
        case .iPhoneXR_XSMax_11_11ProMax:
            slide2.topConstraint.constant = 185
            slide2.bottomConstraint.constant = 30
            slide2.fromBlackToYellow.constant = 185
            slide2.fromTryFreeToProceed.constant = 68
            slide2.fromUpgradeToTop.constant = 90
            slide2.fromNotNowToTop.constant = 45
        case .iPhone12ProMax:
            slide2.topConstraint.constant = 200
            slide2.bottomConstraint.constant = 30
            slide2.fromBlackToYellow.constant = 200
            slide2.fromTryFreeToProceed.constant = 69
            slide2.fromUpgradeToTop.constant = 90
            slide2.fromNotNowToTop.constant = 45
        default:
            break
        }
        
        let slide3: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.yellowView.cornerRadius(to: 0)
        slide3.blackView.cornerRadius(to: 0)
        slide3.upgradeLabel.isHidden = false
        slide3.speedImage.isHidden = false
        slide3.barImage.isHidden = false
        slide3.startFreeLabel.isHidden = false
        slide3.proceedWithBasic.isHidden = false
        slide3.proceedWithBasic.isEnabled = true
        slide3.proceedWithBasic.addLine(position: .LINE_POSITION_BOTTOM, color: .mainGray, width: 0.5)
        slide3.tryFreeButton.isHidden = false
        slide3.tryFreeButton.isEnabled = true
        slide3.tryFreeButton.cornerRadius(to: 10)
        slide3.startMonthlyView.cornerRadius(to: 20)
        slide3.startMonthlyView.addBorder(width: 2.0, color: .mainYellow)
        slide3.startMonthlyButton.isEnabled = true
        slide3.startMonthlySecondButton.isEnabled = true
        slide3.startMonthlyView.isHidden = false
        slide3.yellowView.isHidden = true
        slide3.imageView.isHidden = true
        slide3.locTimerImageView.isHidden = true
        slide3.blackViewLeading.constant = 0
        slide3.blackViewTrailing.constant = 0
        slide3.blackViewBottom.constant = 0
        slide3.gpsLabel.isHidden = true
        slide3.trackLabel.isHidden = true
        slide3.privacyEulaStackView.isHidden = false
        slide3.privacyButton.isEnabled = true
        slide3.privacyButton.addLine(position: .LINE_POSITION_BOTTOM, color: .mainGray, width: 0.5)
        slide3.eulaButton.isEnabled = true
        slide3.eulaButton.addLine(position: .LINE_POSITION_BOTTOM, color: .mainGray, width: 0.5)
        
        switch type {
        case .iPhone5_5S_5C_SE:
            slide3.topConstraint.constant = 123
            slide3.bottomConstraint.constant = 19
            slide3.fromBlackToYellow.constant = 82
            slide3.fromTryFreeToProceed.constant = 34
        case .iPhone6_6S_7_8_SE2:
            slide3.topConstraint.constant = 123
            slide3.bottomConstraint.constant = 19
            slide3.fromBlackToYellow.constant = 82
            slide3.fromTryFreeToProceed.constant = 34
        case .iPhone6Plus_6SPlus_7Plus_8Plus:
            slide3.topConstraint.constant = 123
            slide3.bottomConstraint.constant = 19
            slide3.fromBlackToYellow.constant = 110
            slide3.fromTryFreeToProceed.constant = 71
        case .iPhone12Mini:
            slide3.topConstraint.constant = 148
            slide3.bottomConstraint.constant = 30
            slide3.fromBlackToYellow.constant = 100
            slide3.fromTryFreeToProceed.constant = 72
        case .iPhoneX_XS_11Pro:
            slide3.topConstraint.constant = 170
            slide3.bottomConstraint.constant = 30
            slide3.fromBlackToYellow.constant = 110
            slide3.fromTryFreeToProceed.constant = 72
            slide3.fromUpgradeToTop.constant = 85 // ++9
            slide3.fromNotNowToTop.constant = 40 // ++5
        case .iPhone12_12Pro:
            slide3.topConstraint.constant = 200
            slide3.bottomConstraint.constant = 30
            slide3.fromBlackToYellow.constant = 118
            slide3.fromTryFreeToProceed.constant = 67
            slide3.fromUpgradeToTop.constant = 90 // ++14
            slide3.fromNotNowToTop.constant = 45 // ++10
        case .iPhoneXR_XSMax_11_11ProMax:
            slide3.topConstraint.constant = 185
            slide3.bottomConstraint.constant = 30
            slide3.fromBlackToYellow.constant = 185
            slide3.fromTryFreeToProceed.constant = 68
            slide3.fromUpgradeToTop.constant = 90 // ++14
            slide3.fromNotNowToTop.constant = 45 // ++10
        case .iPhone12ProMax:
            slide3.topConstraint.constant = 200
            slide3.bottomConstraint.constant = 30
            slide3.fromBlackToYellow.constant = 200
            slide3.fromTryFreeToProceed.constant = 69
            slide3.fromUpgradeToTop.constant = 90 // ++14
            slide3.fromNotNowToTop.constant = 45 // ++10
        default:
            break
        }
        
        return [slide1, slide2, slide3]
    }
    
    @IBAction func notNowTapped(_ sender: Any) {
        print("Tapped not now")
        NotificationCenter.default.post(name: dismissNotification, object: nil)
    }
    
    @IBAction func proceedWithBasicTapped(_ sender: Any) {
        print("Proceed Tapped")
        NotificationCenter.default.post(name: dismissNotification, object: nil)
    }
    
    @IBAction func tryFreeTapped(_ sender: Any) {
        print("Try free tapped")
        let userInfo = ["index": 2]
        NotificationCenter.default.post(name: subTypeNotificationIndex, object: nil, userInfo: userInfo)
    }
    
    @IBAction func startMonthlyTapped(_ sender: Any) {
        print("StartMonthly tapped")
        let userInfo = ["index": 0]
        NotificationCenter.default.post(name: subTypeNotificationIndex, object: nil, userInfo: userInfo)
    }
    
    @IBAction func privacyTapped(_ sender: Any) {
        print("privacy tapped")
        openURL(path: kPolicyURL)
    }
    
    @IBAction func eulaTapped(_ sender: Any) {
        print("terms tapped")
        openURL(path: kTermsURL)
    }
}
