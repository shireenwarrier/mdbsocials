//
//  InterestedUsersTableViewCell.swift
//  MDBSocials
//
//  Created by Shireen Warrier on 3/2/17.
//  Copyright © 2017 Shireen Warrier. All rights reserved.
//

import UIKit

class InterestedUsersTableViewCell: UITableViewCell {
    var userLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        userLabel = UILabel(frame: CGRect(x: contentView.frame.minX + 30, y: contentView.frame.minY + 10, width: contentView.frame.width - 60, height: contentView.frame.height - 20))
        userLabel.textColor = UIColor.black
        userLabel.font = UIFont(name: "Apple SD Gothic Neo", size: userLabel.font.pointSize)
        contentView.addSubview(userLabel)
    }

}
