//
//  HistoryTableViewCell.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/24/21.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var graphBackgroundView: UIView!
    @IBOutlet weak var detailsStackView: UIStackView!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var minSpeedLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var topSpeedLabel: UILabel!
    @IBOutlet weak var bottomSpeedLabel: UILabel!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var calendarImageView: UIImageView!
    
    // MARK: - Properties
    var graphConstraints = [NSLayoutConstraint]()
    var graph: Graph!
    var data: [Double] = [0, 1]
    
    var historyModel: HistoryCellModel! {
        didSet {
            maxSpeedLabel.text = historyModel.historyMaxSpeed
            minSpeedLabel.text = historyModel.historyMinSpeed
            topSpeedLabel.text = historyModel.historyMaxSpeed
            bottomSpeedLabel.text = historyModel.historyMinSpeed
            averageSpeedLabel.text = historyModel.historyAvrSpeed
            windLabel.text = historyModel.historyWindSpeed
            durationLabel.text = historyModel.historyDuration
            distanceLabel.text = historyModel.historyDistance
            durationLabel.text = historyModel.historyDuration
            data = historyModel.historyAllSpeeds.maximum() > 0 ? historyModel.historyAllSpeeds : [0, 1]
            calendarView.subviews.forEach { (view) in
                if view != graphView {
                    graphView.removeFromSuperview()
                    calendarView.addSubview(graphView)
                    setupConstraints()
                }
            }
        }
    }
    
    lazy var graphView: UIView = {
        graph = Graph(data: data)
        let view = graph.createBarGraph(calendarView.frame)
        return view
    }()
    
    // MARK: - Override Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .mainBlack
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        data = [0, 1]
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.mainYellow
        
        if selected {
            backgroundColor = .mainYellow
            selectedBackgroundView = backgroundView
        }
    }
    
    // MARK: - Functions
    private func setupConstraints() {
        
        self.graphView.translatesAutoresizingMaskIntoConstraints = false
        graphConstraints.removeAll()
        
        let topConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.calendarView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: -8)
        let rightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.calendarView, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.calendarView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 8)
        let leftConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.calendarView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
        
        //let heightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        
        graphConstraints.append(topConstraint)
        graphConstraints.append(bottomConstraint)
        graphConstraints.append(leftConstraint)
        graphConstraints.append(rightConstraint)
        
        //graphConstraints.append(heightConstraint)
        
        self.contentView.addConstraints(graphConstraints)
    }
}
