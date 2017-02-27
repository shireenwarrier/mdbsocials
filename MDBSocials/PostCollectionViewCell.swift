//
//  PostCollectionViewCell.swift
//  MDBSocials
//
//  Created by Shireen Warrier on 2/24/17.
//  Copyright © 2017 Shireen Warrier. All rights reserved.
//

import UIKit
import Firebase

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
        eventNameLabel = UILabel(frame: CGRect(x: contentView.frame.minX + 10, y: contentView.frame.minY + 10, width: self.frame.width, height: 30))
        eventNameLabel.textColor = UIColor.black
        eventNameLabel.font = UIFont.systemFont(ofSize: 24, weight: 2)
        eventNameLabel.adjustsFontForContentSizeCategory = true
        
        usernameLabel = UILabel(frame: CGRect(x: contentView.frame.minX + 10, y: eventNameLabel.frame.maxY + 10, width: self.frame.width, height: 30))
        usernameLabel.textColor = UIColor.black
        usernameLabel.adjustsFontForContentSizeCategory = true
        
        imageView = UIImageView(frame: CGRect(x: contentView.frame.minX + 10, y: usernameLabel.frame.maxY + 10, width: 50, height: 50))
        
        interestedLabel = UILabel(frame: CGRect(x: contentView.frame.minX + 10, y: imageView.frame.maxY + 10, width: self.frame.width, height: 30))
        interestedLabel.textColor = UIColor.black
        interestedLabel.font = UIFont.systemFont(ofSize: 24, weight: 2)
        interestedLabel.adjustsFontForContentSizeCategory = true
        
        
        addSubview(eventNameLabel)
        addSubview(usernameLabel)
        addSubview(imageView)
        addSubview(interestedLabel)
    }
    
}
