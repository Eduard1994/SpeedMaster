//
//  SettingsTableViewCell.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/20/21.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var settingsImageView: UIImageView!
    @IBOutlet weak var settingsTitle: UILabel!
    @IBOutlet weak var disclosureButton: UIButton!
    @IBOutlet weak var speedLabel: UILabel!
    
    // MARK: - Properties
    var settingsModel: SettingsCellModel! {
        didSet {
            settingsImageView.image = nil
            settingsTitle.text = settingsModel.settingsTitle
            speedLabel.text = settingsModel.speed
            settingsImageView.image = imageNamed(settingsModel.settingsImageName)
        }
    }
    
    // MARK: - Override Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .mainBlack
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
}
