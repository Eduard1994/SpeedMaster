//
//  SettingsViewController.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import UIKit
import StoreKit
import MessageUI

let scrollViewContentHeight = 1200 as CGFloat

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var upgradeView: UIView!
    @IBOutlet weak var upgradeLabel: UILabel!
    @IBOutlet weak var enjoyLabel: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var upgradeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    
    // MARK: - Properties
    lazy var upgradeFromSettingsVC: UpgradeFromSettingsViewController = {
        let vc = UpgradeFromSettingsViewController.instantiate(from: .Premium, with: UpgradeFromSettingsViewController.typeName)
        return vc
    }()
    
    lazy var measureVC: MeasureViewController = {
        let vc = MeasureViewController.instantiate(from: .Main, with: MeasureViewController.typeName)
        return vc
    }()
    
    var settings: [Settings] = [] {
        didSet {
            self.reloadTableView()
        }
    }
    
    // MARK: - Override properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
    
    var products: [SKProduct] = []
    var store: IAPManager!
    var subscriptions: Subscriptions = Subscriptions()
    let service = Service()
    
    // MARK: - View LyfeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Functions
    private func configureView() {
        upgradeButton.cornerRadius(to: 10)
        
        tableView.register(UINib(nibName: SettingsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SettingsTableViewCell.identifier)
        
        tableView.backgroundColor = .mainBlack
        tableView.cornerRadius(to: 25)
        tableView.withoutSeparator()
        
        tableView.estimatedRowHeight = 65
        tableView.rowHeight = UITableView.automaticDimension
        
        tableViewHeight.constant = view.frame.height - 200
        tableView.isScrollEnabled = false
        
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        
        print(upgradeView.height)
        print(tableView.height)
        print(scrollView.height)
        
        reloadSettings()
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve) {
                self.tableView.reloadData()
            } completion: { (_) in
                self.provideHaptic()
            }
        }
    }
    
    private func reloadSettings() {
        settings = Settings.settings()
    }
    
    private func contactUs() {
        self.alert(title: nil, message: "Do you want to contact us?", preferredStyle: .actionSheet, cancelTitle: "Cancel", cancelHandler: nil, actionTitle: "Contact via Email") {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([kEmail])
                mail.setCcRecipients([kCCRecipentEmail])
                mail.setSubject("Subject of the Mail.")
                self.present(mail, animated: true)
            } else {
                openURL(path: "mailto:\(kEmail)")
            }
        }
    }
    
    private func shareApp() {
        guard let url = URL(string: kAppURL) else { return }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.print]
        activityVC.completionWithItemsHandler = { _, completed, _, _ in
            if completed {
            }
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    // MARK: - OBJC Functions
    @objc private func notifiedToUpgrade() {
        
    }
    
    @objc private func notifiedToShowError() {
        ErrorHandling.showError(message: NetworkError.noInternet.localizedDescription, controller: self)
    }
    
    // MARK: - IBActions
    @IBAction func upgradeTapped(_ sender: Any) {
        presentOverFullScreen(upgradeFromSettingsVC, animated: true)
//        print("Upgrade tapped")
//        upgradeViewHeight.constant = 0
//        upgradeView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//        tableViewTop.constant = 60
//        self.reloadSettings()
    }
}

// MARK: - TableView Delegate & DataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
        let setting = settings[indexPath.row]
        cell.settingsModel = SettingsCellModel(setting)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            print("Measure Tapped")
            measureVC.delegate = self
            push(measureVC, animated: true)
        case 1:
            print("Restoring...") // Will be updated
        case 2:
            openURL(path: kPolicyURL)
        case 3:
            openURL(path: kTermsURL)
        case 4:
            print("Rate Tapped") // Will be updated
        case 5:
            print("Share Tapped")
            shareApp()
        case 6:
            print("Support Tapped")
            contactUs()
        default:
            break
        }
    }
}

// MARK: - Mail Delegate
extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

// MARK: - Units Updation Delegate
extension SettingsViewController: UpdateUnit {
    func updatedUnit(unit: Unit) {
        Settings.unit = unit
        reloadSettings()
        NotificationCenter.default.post(name: unitChangedNotification, object: nil)
    }
}
