//
//  SettingsViewController.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import UIKit
//import StoreKit
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
            tableViewHeight.constant = tableView.estimatedRowHeight * CGFloat(settings.count)
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
    
    let service = Service()
    
    // MARK: - View LyfeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("All Prices = \(allPrices)")
        print("All Products = \(allProducts)")
        print("All Product IDs = \(allProductIDs)")
        print("Purchased = \(purchasedAny)")
        
        reloadViewIfUpgraded()
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
        
//        tableViewHeight.constant = view.frame.height - 200
        tableView.isScrollEnabled = false
        
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        
        print(upgradeView.height)
        print(tableView.height)
        print(scrollView.height)
        
        getSettingsTitles()
        
        reloadSettings()
    }
    
    /// Get Settings Titles
    private func getSettingsTitles() {
        service.getSettingsTitles(for: PremiumTab.Settings.rawValue) { (settingsTitle, error) in
            if let error = error {
                DispatchQueue.main.async {
                    ErrorHandling.showError(message: error.localizedDescription, controller: self)
                    self.configureTitles(settings: SettingsTitle())
                }
                return
            }
            if let settingsTitle = settingsTitle {
                DispatchQueue.main.async {
                    self.configureTitles(settings: settingsTitle)
                }
            }
        }
    }
    
    private func configureTitles(settings: SettingsTitle) {
        self.upgradeLabel.text = settings.firstTitle
        self.enjoyLabel.text = settings.secondTitle
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
    
    /// Reloading view after upgrading/restoring products
    private func reloadViewIfUpgraded() {
        if purchasedAny {
            tableView.isScrollEnabled = true
            upgradeViewHeight.constant = 0
            tableViewTop.constant = 60
            reloadSettings()
        }
    }
    
    private func contactUs() {
        self.alert(title: nil, message: "Do you want to contact us?", preferredStyle: .actionSheet, cancelTitle: "Cancel", cancelHandler: nil, actionTitle: "Contact via Email") {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([kEmail])
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
    
    // MARK: - Presenting UpgradeFromSettingsVC
    private func presentUpgradeFromSettingsVC(with productIDs: Set<ProductID>, allPrices: [String: String]) {
        var annualPrice: String = "--"
        var monthlyPrice: String = "--"
        var weeklyPrice: String = "--"
        for (title, price) in allPrices {
            if title.contains("Monthly") {
                monthlyPrice = price
            } else if title.contains("Yearly") {
                annualPrice = price
            } else if title.contains("Weekly") {
                weeklyPrice = price
            }
        }
        upgradeFromSettingsVC.productIDs = productIDs
        upgradeFromSettingsVC.monthlyPrice = monthlyPrice
        upgradeFromSettingsVC.annualPrice = annualPrice
        upgradeFromSettingsVC.weeklyPrice = weeklyPrice
        
        upgradeFromSettingsVC.delegate = self
        if presentedViewController != upgradeFromSettingsVC {
            self.presentOverFullScreen(upgradeFromSettingsVC, animated: true)
        }
    }
    
    /// Trying to restore purchases
    private func restorePurchases() {
        displayAnimatedActivityIndicatorView()
        IAPHelper.shared.restorePurchases { (results) in
            IAPHelper.shared.finishingRestoring(restoreResults: results)
            if results.restoreFailedPurchases.count > 0 {
                self.hideAnimatedActivityIndicatorView()
                ErrorHandling.showError(title: "Restore Failed", message: "Please check Internet Connectivity and try again or Contact Support", controller: self)
                print("Restore Failed: \(results.restoreFailedPurchases), Please contact support")
            } else if results.restoredPurchases.count > 0 {
                self.hideAnimatedActivityIndicatorView()
                purchasedAny = true
                self.alert(title: "Restored Successfully", message: nil, preferredStyle: .alert, cancelTitle: nil, cancelHandler: nil, actionTitle: "OK", actionHandler: {
                    self.reloadViewIfUpgraded()
                })
                print("Restore Success: \(results.restoredPurchases), All purchases have been restored")
            } else {
                print("Nothing to Restore, No previous purchases were found")
                self.hideAnimatedActivityIndicatorView()
                ErrorHandling.showError(title: "Nothing to Restore", message: "No previous purchases were found", controller: self)
            }
        }
    }
    
    // MARK: - OBJC Functions
    
    // MARK: - IBActions
    @IBAction func upgradeTapped(_ sender: Any) {
//        presentOverFullScreen(upgradeFromSettingsVC, animated: true)
        presentUpgradeFromSettingsVC(with: allProductIDs, allPrices: allPrices)
        print("Upgrade tapped")
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
            print("Restoring...")
            restorePurchases()
        case 2:
            openURL(path: kPolicyURL)
        case 3:
            openURL(path: kTermsURL)
        case 4:
            print("Rate Tapped")
            self.alert(title: "Rate the App Feature Coming Soon", message: nil, preferredStyle: .alert, cancelTitle: nil, cancelHandler: nil, actionTitle: "OK", actionHandler: nil)
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

// MARK: - Dismiss From Upgrade Delegate
extension SettingsViewController: UpgradeFromSettingsDelegate {
    func purchased(purchases: [ProductID]) {
        print(purchases)
        print("Purchased")
        print("All Prices = \(allPrices)")
        print("All Products = \(allProducts)")
        print("All Product IDs = \(allProductIDs)")
        print("Purchased = \(purchasedAny)")
        
        reloadViewIfUpgraded()
    }
    
    func dismissFromUpgrade() {
        print("Dismissed")
    }
}

