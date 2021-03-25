//
//  FooterView.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/20/21.
//

import UIKit

class FooterView: UIView {

    let label = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainGray
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.sfProDisplay(ofSize: 18, style: .medium)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100)
        ])
    }
    
    func configure(text: String?) {
        label.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

