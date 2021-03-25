//
//  HistoryTableViewCell.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/24/21.
//

import UIKit
import ScrollableGraphView

class HistoryTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    // MARK: - Properties
    var historyModel: HistoryCellModel! {
        didSet {
//            speedTitle.text = historyModel.historySpeed
//            dateTitle.text = historyModel.historyDate
        }
    }
    
    var examples: Examples!
    var graph: ScrollableGraphView!
    var currentGraphType = GraphType.bar
    var graphConstraints = [NSLayoutConstraint]()
    
    lazy var graphView: UIView = {
        examples = Examples()
        let graphView = examples.createBarGraph(contentView.frame)
        
        return graphView
    }()
    
    // MARK: - Override Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .mainBlack
        
        contentView.addSubview(graphView)
        
        setupConstraints()
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
        
        let topConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: -20)
        let bottomConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 30)
        
        //let heightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        
        graphConstraints.append(topConstraint)
        graphConstraints.append(bottomConstraint)
        graphConstraints.append(leftConstraint)
        graphConstraints.append(rightConstraint)
        
        //graphConstraints.append(heightConstraint)
        
        self.contentView.addConstraints(graphConstraints)
    }
}
