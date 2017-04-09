//
//  PostCollectionViewCell.swift
//  MDBSocials
//
//  Created by Shireen Warrier on 2/24/17.
//  Copyright © 2017 Shireen Warrier. All rights reserved.
//

import UIKit

protocol PostCollectionViewDelegate {
    func addInterestedUser(forCell: PostCollectionViewCell)
}

class PostCollectionViewCell: UICollectionViewCell {
    var eventNameLabel: UILabel!
    var usernameLabel: UILabel!
    var heartImage: UIImage!
    var interestedButton: UIButton!
    var imageView: UIImageView!
    var interestedLabel: UILabel!
    var dateLabel: UILabel!
    var delegate: PostCollectionViewDelegate? = nil
    var postID: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        contentView.backgroundColor = UIColor(red: 236/255, green: 239/255, blue: 241/255, alpha: 1.0)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: contentView.frame.width/3, height: contentView.frame.height))
        
        eventNameLabel = UILabel(frame: CGRect(x: imageView.frame.maxX, y: contentView.frame.minY + 10, width: contentView.frame.width * (2/3) - 30, height: contentView.frame.height/3 - 10))
        eventNameLabel.textColor = UIColor.black
        eventNameLabel.textAlignment = .center
        eventNameLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 24)
        eventNameLabel.adjustsFontForContentSizeCategory = true
        
        dateLabel = UILabel(frame: CGRect(x: imageView.frame.maxX, y: eventNameLabel.frame.maxY + 10, width: contentView.frame.width * (2/3), height: contentView.frame.height/5))
        dateLabel.textColor = UIColor.black
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        dateLabel.adjustsFontForContentSizeCategory = true
        
        usernameLabel = UILabel(frame: CGRect(x: imageView.frame.maxX, y: dateLabel.frame.maxY, width: contentView.frame.width * (2/3), height: contentView.frame.height/5))
        usernameLabel.textColor = UIColor.black
        usernameLabel.textAlignment = .center
        usernameLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        usernameLabel.adjustsFontForContentSizeCategory = true
        
        interestedLabel = UILabel(frame: CGRect(x: imageView.frame.maxX, y: usernameLabel.frame.maxY, width: contentView.frame.width * (2/3), height: contentView.frame.height/5))
        interestedLabel.textColor = UIColor.black
        interestedLabel.textAlignment = .center
        interestedLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        interestedLabel.adjustsFontForContentSizeCategory = true
        
        heartImage = UIImage(named: "heart")!.alpha(0.2)
        interestedButton = UIButton(frame: CGRect(x: eventNameLabel.frame.maxX, y: contentView.frame.minY + 10, width: 30, height: 30))
        interestedButton.layoutIfNeeded()
        interestedButton.setImage(heartImage, for: .normal)
        interestedButton.addTarget(self, action: #selector(addInterested), for: .touchUpInside)
        
        contentView.addSubview(imageView)
        contentView.addSubview(eventNameLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(interestedLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(interestedButton)
        
        contentView.bringSubview(toFront: eventNameLabel)
        contentView.bringSubview(toFront: usernameLabel)
        contentView.bringSubview(toFront: interestedLabel)
        contentView.bringSubview(toFront: dateLabel)
        contentView.bringSubview(toFront: interestedButton)
    }
    
    func addInterested() {
        delegate?.addInterestedUser(forCell: self)
    }
}
