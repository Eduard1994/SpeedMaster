//
//  SortViewController.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/25/21.
//

import UIKit

protocol UpdatedSort: class {
    func updatedSort(sort: Sorting)
}

class SortViewController: UIViewController {
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var sortStackView: UIStackView!
    @IBOutlet var linedViews: [UIView]!
    @IBOutlet weak var okayButton: UIButton!
    
    // MARK: - Properties
    var sort: Sorting = Sorting.selected
    weak var delegate: UpdatedSort?
    
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
        sortView.cornerRadius(to: 24)
        okayButton.cornerRadius(to: 10)
        
        sort = .selected
        prepareSorting()
        
        linedViews.forEach { (view) in
            view.addLine(position: .LINE_POSITION_BOTTOM, color: .black, width: 1)
        }
    }
    
    /// Preparing Sorting
    private func prepareSorting() {
        switch sort {
        case .maxValue:
            setImagesForButton(tags: [100, 110, 120, 130])
        case .minValue:
            setImagesForButton(tags: [110, 100, 120, 130])
        case .newest:
            setImagesForButton(tags: [120, 100, 110, 130])
        case .earlier:
            setImagesForButton(tags: [130, 100, 110, 120])
        }
    }
    
    private func setImagesForButton(tags: [Int]) {
        for i in 1...3 {
            sortStackView.subviews.forEach { (view) in
                if let button = view.viewWithTag(tags[i]) as? UIButton {
                    button.setImage(nil, for: .normal)
                    button.setBackgroundImage(imageNamed("checkBackgroundBlack"), for: .normal)
                }
            }
        }
        sortStackView.subviews.forEach { (view) in
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
        delegate?.updatedSort(sort: sort)
        pop(animated: true)
    }
    
    @IBAction func maximumTapped(_ sender: Any) {
        setImagesForButton(tags: [100, 110, 120, 130])
        sort = sort.max
    }
    
    @IBAction func minimumTapped(_ sender: Any) {
        setImagesForButton(tags: [110, 100, 120, 130])
        sort = sort.min
    }
    
    @IBAction func upcomingTapped(_ sender: Any) {
        setImagesForButton(tags: [120, 100, 110, 130])
        sort = sort.new
    }
    
    @IBAction func earlierTapped(_ sender: Any) {
        setImagesForButton(tags: [130, 100, 110, 120])
        sort = sort.early
    }
}
