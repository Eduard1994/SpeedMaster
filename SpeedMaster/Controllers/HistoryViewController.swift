//
//  HistoryViewController.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import UIKit
//import StoreKit

class HistoryViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var upcomingButton: UIButton!
    @IBOutlet weak var upcomingArrow: UIButton!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var historyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    
    // MARK: - Properties
    lazy var upgradeToPremiumVC: UpgradeToPremiumViewController = {
        let vc = UpgradeToPremiumViewController.instantiate(from: .Premium, with: UpgradeToPremiumViewController.typeName)
        return vc
    }()
    
    lazy var sortVC: SortViewController = {
        let vc = SortViewController.instantiate(from: .Main, with: SortViewController.typeName)
        return vc
    }()
    
    var sectionedHistories: [History] = [] {
        didSet {
            self.reloadTableView()
        }
    }
    
    var historyHeight: CGFloat! {
        willSet {
            DispatchQueue.main.async {
                self.tableViewHeight.constant = newValue
            }
        }
    }
    
    let sectionHeight: CGFloat = 95
    var rowHeight: CGFloat = 0
    
    var currentUser = User.currentUser
    var service = Service()
    
    // MARK: - Override properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
    
    // MARK: -View LyfeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Will appear")
        print("All Prices = \(allPrices)")
        print("All Products = \(allProducts)")
        print("All Product IDs = \(allProductIDs)")
        print("Purchased = \(purchasedAny)")
        
        if !purchasedAny {
            self.presentUpgradeToPremium(with: allProductIDs)
        }
    }
    
    // MARK: - Functions
    private func configureView() {
        upcomingButton.setTitle(Settings.sort.rawValue, for: .normal)
        
        tableView.register(UINib(nibName: HistoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HistoryTableViewCell.identifier)
        
        tableView.backgroundColor = .mainBlack
        tableView.cornerRadius(to: 25)
        tableView.withoutSeparator()
        
        tableView.estimatedRowHeight = 370
        tableView.rowHeight = UITableView.automaticDimension
        
        tableViewHeight.constant = 0
        tableView.isScrollEnabled = false
        scrollView.isScrollEnabled = true
        
        scrollView.delegate = self
        
        tableView.bounces = true
        scrollView.bounces = true
        
        reloadHistories()
    }
    
    // MARK: - Presenting UpgradeToPremiumVC
    private func presentUpgradeToPremium(with productIDs: Set<ProductID>) {
        upgradeToPremiumVC.productIDs = productIDs
        upgradeToPremiumVC.delegate = self
        if presentedViewController != upgradeToPremiumVC {
            self.presentOverFullScreen(upgradeToPremiumVC, animated: true)
        }
    }
    
    private func reloadTableView() {
        tableView.reload(for: sectionedHistories, upcomingButton: upcomingButton, upcomingArrow: upcomingArrow, tableViewHeight: tableViewHeight)
        
        DispatchQueue.main.async {
            UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve) {
                self.tableView.reloadData()
            } completion: { (_) in
                self.provideHaptic()
            }
        }
    }
    
    private func reloadHistories() {
        guard let user = currentUser else {
            service.checkUser { (user, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        ErrorHandling.showError(message: error.localizedDescription, controller: self)
                        return
                    }
                }
                if let user = user {
                    self.currentUser = user
                    self.reloadHistories()
                } else {
                    ErrorHandling.showError(message: "Server error, try again later", controller: self)
                    return
                }
            }
            return
        }
        
        let uid = user.uid
        
        service.getHistories(userID: uid) { (sectioned, error) in
            if let error = error {
                DispatchQueue.main.async {
                    ErrorHandling.showError(message: error.localizedDescription, controller: self)
                    self.sectionedHistories.removeAll()
                }
            }
            if let sectioned = sectioned {
                switch Settings.sort {
                case .maxValue:
                    self.sectionedHistories = sectioned.sorted(by: {$0.maxSpeed > $1.maxSpeed})
                case .minValue:
                    self.sectionedHistories = sectioned.sorted(by: {$0.maxSpeed < $1.maxSpeed})
                case .newest:
                    self.sectionedHistories = sectioned.sorted(by: {$0.date > $1.date})
                case .earlier:
                    self.sectionedHistories = sectioned.sorted(by: {$0.date < $1.date})
                }
                if self.sectionedHistories.count != 0 {
                    self.historyHeight = self.sectionHeight * CGFloat(self.sectionedHistories.count)
                }
            }
        }
    }
    
    private func removeHistory(history: History) {
        guard let userID = currentUser?.uid else {
            ErrorHandling.showError(message: "No User found", controller: self)
            return
        }
        service.removeHistory(withID: history.id, userID: userID) { (error) in
            if let error = error {
                ErrorHandling.showError(message: error.localizedDescription, controller: self)
            }
        }
    }
    
    private func updateScrollView(_ scrollView: UIScrollView, tableViewContentOffset: CGFloat, scrollViewContentOffset: CGFloat) {
        if scrollView == self.scrollView {
            print("ScrollView's contentOfset.y = \(scrollView.contentOffset.y)")
            tableView.isScrollEnabled = scrollView.contentOffset.y >= scrollViewContentOffset
        }

        if scrollView == self.tableView {
            print("TableView's contentOfset.y = \(tableView.contentOffset.y)")
            tableView.isScrollEnabled = tableView.contentOffset.y > tableViewContentOffset
        }
    }
    
    // MARK: - IBActions
    @IBAction func upcomingTapped(_ sender: Any) {
        print("Upcoming tapped")
        sortVC.delegate = self
        push(sortVC, animated: true)
    }
}

// MARK: - UITableViewDelegate & DataSource
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionedHistories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionedHistories[section].collapsed ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as! HistoryTableViewCell
        let history = sectionedHistories[indexPath.section]
        cell.historyModel = HistoryCellModel(history)
        rowHeight = cell.height
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let history = sectionedHistories[indexPath.section]
        let deleteAction: UIContextualAction.Handler = { action, view, completion in
            self.alert(title: nil, message: "Are you sure, you want to delete this result?", preferredStyle: .alert, cancelTitle: "No", cancelHandler: nil, actionTitle: "Yes, sure", actionHandler: {
                self.removeHistory(history: history)
            })
            completion(true)
        }
        let delete = UIContextualAction(style: .destructive, title: "Delete", handler: deleteAction)
        delete.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? SectionHeader ?? SectionHeader(reuseIdentifier: "header")
        let history = sectionedHistories[section]
        let speed = history.maxSpeed
        let date = history.date
        
        header.speedLabel.text = "\(speed) \(history.speedMetric)"
        header.dateLabel.text = date
        header.setCollapsed(!history.collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: .zero)
        footer.backgroundColor = .mainDark
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
}

// MARK: - ScrollViewDelegate
extension HistoryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        updateScrollView(scrollView, tableViewContentOffset: -100, scrollViewContentOffset: -1)
    }
}

// MARK: - SectionHeader Delegate
extension HistoryViewController: SectionHeaderDelegate {
    func toggleSection(_ header: SectionHeader, section: Int) {
        let collapsed = !sectionedHistories[section].collapsed
        
        // Toggle collapse
        sectionedHistories[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        historyHeight = collapsed ? historyHeight - 370 : historyHeight + 370
    }
}

// MARK: - Sorting Delegate
extension HistoryViewController: UpdatedSort {
    func updatedSort(sort: Sorting) {
        Settings.sort = sort
        upcomingButton.setTitle(sort.rawValue, for: .normal)
        reloadHistories()
        NotificationCenter.default.post(name: sortChangedNotification, object: nil)
    }
}

// MARK: - Dismiss From Upgrade Delegate
extension HistoryViewController: UpgradeFromHistoryDelegate {
    func purchased(purchases: [ProductID]) {
        print(purchases)
        print("Purchased")
        print("All Prices = \(allPrices)")
        print("All Products = \(allProducts)")
        print("All Product IDs = \(allProductIDs)")
        print("Purchased = \(purchasedAny)")
    }
    
    func dismissFromUpgrade() {
        print("Dismissed")
        self.tabBarController?.selectedIndex = 1
    }
}
