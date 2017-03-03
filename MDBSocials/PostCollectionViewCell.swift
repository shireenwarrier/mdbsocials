//
//  PostCollectionViewCell.swift
//  MDBSocials
//
//  Created by Shireen Warrier on 2/24/17.
//  Copyright © 2017 Shireen Warrier. All rights reserved.
//

import UIKit
import Firebase

protocol PostCollectionViewDelegate {
    func addInterestedUser(forCell: PostCollectionViewCell)
}

class PostCollectionViewCell: UICollectionViewCell {
    var eventNameLabel: UILabel!
    var usernameLabel: UILabel!
    var imageView: UIImageView!
    var interestedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        setupUI()
    }
    
    func setupUI() {
        eventNameLabel = UILabel(frame: CGRect(x: contentView.frame.minX + 10, y: contentView.frame.minY + 10, width: self.frame.width/2, height: contentView.frame.height/3 - 10))
        eventNameLabel.textColor = UIColor.black
        eventNameLabel.font = UIFont.systemFont(ofSize: 24, weight: 1)
        eventNameLabel.adjustsFontForContentSizeCategory = true
        eventNameLabel.layer.borderColor = Constants.feedBorderColor
        
        usernameLabel = UILabel(frame: CGRect(x: contentView.frame.minX + 10, y: eventNameLabel.frame.maxY + 10, width: self.frame.width/2, height: contentView.frame.height/3 - 10))
        usernameLabel.textColor = UIColor.black
        usernameLabel.font = UIFont.systemFont(ofSize: 24, weight: 1)
        usernameLabel.adjustsFontForContentSizeCategory = true
        usernameLabel.layer.borderColor = Constants.feedBorderColor
        
        imageView = UIImageView(frame: CGRect(x: contentView.frame.width/2 + 10, y: contentView.frame.minY, width: contentView.frame.width/2 - 10, height: contentView.frame.height - 10))
        
        interestedLabel = UILabel(frame: CGRect(x: contentView.frame.minX + 10, y: usernameLabel.frame.maxY + 10, width: self.frame.width/2, height: contentView.frame.height/3 - 10))
        interestedLabel.textColor = UIColor.black
        interestedLabel.font = UIFont.systemFont(ofSize: 24, weight: 1)
        interestedLabel.font = UIFont.systemFont(ofSize: 24, weight: 2)
        interestedLabel.adjustsFontForContentSizeCategory = true
        interestedLabel.layer.borderColor = Constants.feedBorderColor
        
        
        addSubview(eventNameLabel)
        addSubview(usernameLabel)
        addSubview(imageView)
        addSubview(interestedLabel)
    }
    
}
