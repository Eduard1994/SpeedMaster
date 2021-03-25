//
//  HistoryViewController.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import UIKit

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
    lazy var sortVC: SortViewController = {
        let vc = SortViewController.instantiate(from: .Main, with: SortViewController.typeName)
        return vc
    }()
    
    var sectionedHistories: [History] = [] {
        didSet {
            self.reloadTableView()
        }
    }
    
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
    
    // MARK: - Functions
    private func configureView() {
        tableView.register(UINib(nibName: HistoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HistoryTableViewCell.identifier)
        
        tableView.backgroundColor = .mainBlack
        tableView.cornerRadius(to: 25)
        tableView.withoutSeparator()
        
        tableView.estimatedRowHeight = 95
        tableView.rowHeight = UITableView.automaticDimension
        
        tableViewHeight.constant = view.frame.height - 100
        tableView.isScrollEnabled = false
        scrollView.isScrollEnabled = true
        
        scrollView.delegate = self
        
        tableView.bounces = true
        scrollView.bounces = true
        
        print(tableView.height)
        print(scrollView.height)
        
        reloadHistories()
    }
    
    private func reloadTableView() {
        tableView.reload(for: sectionedHistories, upcomingButton: upcomingButton, upcomingArrow: upcomingArrow)
        
        DispatchQueue.main.async {
            UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve) {
                self.tableView.reloadData()
            } completion: { (_) in
                self.provideHaptic()
            }
        }
    }
    
    private func reloadHistories() {
        let uid = currentUser?.uid ?? ""
        service.getHistories(userID: uid) { (sectioned, error) in
            if let error = error {
                ErrorHandling.showError(message: error.localizedDescription, controller: self)
                self.sectionedHistories = []
            }
            if let sectioned = sectioned {
                self.sectionedHistories = sectioned
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
    
    @IBAction func upcomingTapped(_ sender: Any) {
        print("Upcoming tapped")
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? SectionHeader ?? SectionHeader(reuseIdentifier: "header")
        
        let speed = sectionedHistories[section].speed
        let date = sectionedHistories[section].date
        
        header.speedLabel.text = speed
        header.dateLabel.text = date
        header.setCollapsed(!sectionedHistories[section].collapsed)
        
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
        return 95
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
}

// MARK: - ScrollViewDelegate
extension HistoryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateScrollView(scrollView, tableViewContentOffset: -100, scrollViewContentOffset: -1)
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
    }
}
