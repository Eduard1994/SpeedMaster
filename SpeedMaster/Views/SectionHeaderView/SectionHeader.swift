//
//  SectionHeader.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/24/21.
//

import UIKit

protocol SectionHeaderDelegate {
    func toggleSection(_ header: SectionHeader, section: Int)
}

class SectionHeader: UITableViewHeaderFooterView {
    // MARK: - Properties
    var delegate: SectionHeaderDelegate?
    var section: Int = 0
    
    let speedLabel = UILabel()
    let maxSpeedLabel = UILabel()
    let dateLabel = UILabel()
    let arrow = UIImageView()
    
    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        // Content View
        contentView.backgroundColor = .mainBlack
        
        let marginGuide = contentView.layoutMarginsGuide
        
        print(marginGuide)
        
        // Arrow button
        contentView.addSubview(arrow)
        arrow.contentMode = .scaleAspectFit
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.widthAnchor.constraint(equalToConstant: 25).isActive = true
        arrow.heightAnchor.constraint(equalToConstant: 25).isActive = true
        arrow.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        arrow.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        arrow.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        
        // Speed label
        contentView.addSubview(speedLabel)
        speedLabel.textColor = .mainWhite
        speedLabel.font = .sfProDisplay(ofSize: 20, style: .blackItalic)
        speedLabel.translatesAutoresizingMaskIntoConstraints = false
        speedLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24).isActive = true
        speedLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -45).isActive = true
        speedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35).isActive = true
        
        contentView.addSubview(maxSpeedLabel)
        maxSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        maxSpeedLabel.textColor = .mainDarkGray
        maxSpeedLabel.font = .sfProText(ofSize: 11, style: .semibold)
        maxSpeedLabel.text = "MAX SPEED"
        maxSpeedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35).isActive = true
        maxSpeedLabel.topAnchor.constraint(equalTo: speedLabel.bottomAnchor).isActive = true
        
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .mainDarkGray
        dateLabel.font = .sfProDisplay(ofSize: 12, style: .regular)
        dateLabel.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: arrow.leadingAnchor, constant: -15).isActive = true
        
        // Call tapHeader when tapping on this header
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SectionHeader.tapHeader(_:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func setCollapsed(_ collapsed: Bool) {
        // Animate the arrow rotation
        DispatchQueue.main.async {
            self.arrow.image = collapsed ? imageNamed("collapsibleButtonUp") : imageNamed("collapsibleButtonDown")
//            self.arrowButton.setImage(collapsed ? imageNamed("collapsibleButtonUp") : imageNamed("collapsibleButtonDown"), for: .normal)
        }
    }
    
    // MARK: - OBJC Functions
    /// Trigger toggle section when tapping on the header
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? SectionHeader else {
            return
        }
        
        delegate?.toggleSection(self, section: cell.section)
    }
}

