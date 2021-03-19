//
//  UITableView+Extension.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/17/21.
//

import UIKit

//MARK: UITableView
extension UITableView {
    public var indexPaths: [IndexPath] {
        return (0..<numberOfSections).map { sectionIndex in
            (0..<numberOfRows(inSection: sectionIndex)).map { rowIndex in
                IndexPath(row: rowIndex, section: sectionIndex)
            }
        }.flatMap { $0 }
    }
    
    public var cells: [UITableViewCell] {
        var cells = [UITableViewCell]()
        for section in 0...numberOfSections - 1 {
            for row in 0...numberOfRows(inSection: section) - 1 {
                if let cell = cellForRow(at: IndexPath(row: row, section: section)) {
                    cells.append(cell)
                }
            }
        }
        return cells
    }
    
    func reload(_ cell: UITableViewCell, animation: UITableView.RowAnimation = .none) {
        if let indexPath = indexPath(for: cell) {
            reloadRows(at: [indexPath], with: animation)
        }
    }
    
    func reload(for codes: [Any], emptyLabeltext: String) {
        if codes.isEmpty {
            let label = UILabel()
            label.text = emptyLabeltext
            label.textColor = UIColor.gray
            label.textAlignment = .center
            label.font = .sfProText(ofSize: 25, style: .medium)
            self.backgroundView = label
            self.withoutSeparator()
        } else {
            self.backgroundView = nil
            self.withSeparator()
        }
    }
    
    func withSeparator() {
        self.separatorColor = .mainGrayAverage
    }
    
    func withoutSeparator() {
        self.separatorColor = .clear
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func scrollTo(_ indexPath: IndexPath) {
        self.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }
    
    func reloadAndScrollToFirstRow(animated: Bool = false) {
        reloadData()
        
        DispatchQueue.main.after(0.05) {
            guard self.numberOfSections > 0, self.numberOfRows(inSection: 0) > 0 else { return }
            
            let indexPath = IndexPath(row: 0, section: 0)
            
            if animated {
                self.scrollToRow(at: indexPath, at: .top, animated: true)
            } else {
                UIView.performWithoutAnimation {
                    self.scrollToRow(at: indexPath, at: .top, animated: false)
                }
            }
        }
    }
    
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    
    func addBlurForTable(style: UIBlurEffect.Style, color: UIColor? = nil) {
        self.backgroundColor = color
        let blureffect = UIBlurEffect(style: style)
        let blureffectView = UIVisualEffectView(effect: blureffect)
        blureffectView.frame = self.frame
        
        self.backgroundView = blureffectView
    }
}

// MARK: - UITableViewCell
extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    func shake(duration: CFTimeInterval = 0.3, pathLength: CGFloat = 15) {
        let position: CGPoint = self.center
        
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: position.x, y: position.y))
        path.addLine(to: CGPoint(x: position.x-pathLength, y: position.y))
        path.addLine(to: CGPoint(x: position.x+pathLength, y: position.y))
        path.addLine(to: CGPoint(x: position.x-pathLength, y: position.y))
        path.addLine(to: CGPoint(x: position.x+pathLength, y: position.y))
        path.addLine(to: CGPoint(x: position.x, y: position.y))
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        
        positionAnimation.path = path.cgPath
        positionAnimation.duration = duration
        positionAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        CATransaction.begin()
        self.layer.add(positionAnimation, forKey: nil)
        CATransaction.commit()
    }
}

//MARK: UICollectionView
extension UICollectionView {
    func reloadAndScrollToFirstItem(animated: Bool = false) {
        if !animated {
            UIView.performWithoutAnimation {
                reloadData()
            }
        } else {
            reloadData()
        }
        
        DispatchQueue.main.after(0.05) {
            guard self.numberOfSections > 0, self.numberOfItems(inSection: 0) > 0 else { return }
            
            let indexPath = IndexPath(item: 0, section: 0)
            
            var position: UICollectionView.ScrollPosition
            if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
                position = layout.scrollDirection == .horizontal ? .centeredHorizontally :
                    .centeredVertically
            } else {
                position = .centeredVertically
            }
            
            if animated {
                self.scrollToItem(at: indexPath, at: position, animated: true)
            } else {
                UIView.performWithoutAnimation {
                    self.scrollToItem(at: indexPath, at: position, animated: false)
                }
            }
        }
    }
    
    func addBlurForCollection(style: UIBlurEffect.Style, color: UIColor? = nil) {
        self.backgroundColor = color
        let blureffect = UIBlurEffect(style: style)
        let blureffectView = UIVisualEffectView(effect: blureffect)
        blureffectView.frame = self.frame
        
        self.backgroundView = blureffectView
    }
    
    // MARK: - UICollectionView scrolling/datasource
    var indexPath: IndexPath {
        return indexPathsForVisibleItems.last!
    }
    /// Last Section of the CollectionView
    var lastSection: Int {
        return numberOfSections - 1
    }
    
    /// IndexPath of the last item in last section.
    var lastIndexPath: IndexPath? {
        guard lastSection >= 0 else {
            return nil
        }
        
        let lastItem = numberOfItems(inSection: lastSection) - 1
        guard lastItem >= 0 else {
            return nil
        }
        
        return IndexPath(item: lastItem, section: lastSection)
    }
    
    /// Islands: Scroll to bottom of the CollectionView
    /// by scrolling to the last item in CollectionView
    func scrollTo(_ position: UICollectionView.ScrollPosition, animated: Bool) {
        guard let lastIndexPath = lastIndexPath else {
            return
        }
        scrollToItem(at: lastIndexPath, at: position, animated: animated)
    }
}



