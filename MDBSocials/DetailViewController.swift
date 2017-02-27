//
//  DetailViewController.swift
//  MDBSocials
//
//  Created by Shireen Warrier on 2/25/17.
//  Copyright © 2017 Shireen Warrier. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    var userLabel: UILabel!
    var eventLabel: UILabel!
    var eventImage: UIImageView!
    var numInterestedButton: UIButton!
    var descriptionView: UITextView!
    var isInterestedButton: UIButton!
    var auth = FIRAuth.auth()
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    var selectedPostID: String?

    override func viewDidLoad() {
        getInfo()
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        userLabel = UILabel(frame: CGRect(x: 20, y: navigationController!.navigationBar.frame.maxY + 10, width: view.frame.width - 40, height: 30))
        userLabel.layoutIfNeeded()
        userLabel.textColor = UIColor.black
        userLabel.layer.borderWidth = 2.0
        userLabel.layer.cornerRadius = 3.0
        userLabel.layer.borderColor = UIColor.blue.cgColor
        userLabel.layer.masksToBounds = true
        
        eventLabel = UILabel(frame: CGRect(x: 20, y: userLabel.frame.maxY + 10, width: view.frame.width - 40, height: 30))
        eventLabel.layoutIfNeeded()
        eventLabel.textColor = UIColor.black
        eventLabel.layer.borderWidth = 2.0
        eventLabel.layer.cornerRadius = 3.0
        eventLabel.layer.borderColor = UIColor.blue.cgColor
        eventLabel.layer.masksToBounds = true
        
        eventImage = UIImageView(frame: CGRect(x: 0, y: eventLabel.frame.maxY + 10, width: view.frame.width, height: 200))
        eventImage.layoutIfNeeded()
        eventImage.layer.borderWidth = 2.0
        eventImage.layer.cornerRadius = 3.0
        eventImage.layer.borderColor = UIColor.blue.cgColor
        eventImage.layer.masksToBounds = true
        
        numInterestedButton = UIButton(frame: CGRect(x: 0, y: eventImage.frame.maxY + 10, width: view.frame.width, height: 30))
        numInterestedButton.layoutIfNeeded()
        numInterestedButton.setTitleColor(UIColor.black, for: .normal)
        numInterestedButton.layer.borderWidth = 2.0
        numInterestedButton.layer.cornerRadius = 3.0
        numInterestedButton.layer.borderColor = UIColor.blue.cgColor
        numInterestedButton.layer.masksToBounds = true
        
        descriptionView = UITextView(frame: CGRect(x: 0, y: numInterestedButton.frame.maxY + 10, width: view.frame.width, height: 200))
        descriptionView.layoutIfNeeded()
        descriptionView.textColor = UIColor.black
        descriptionView.layer.borderWidth = 2.0
        descriptionView.layer.cornerRadius = 3.0
        descriptionView.layer.borderColor = UIColor.blue.cgColor
        descriptionView.layer.masksToBounds = true
        
        isInterestedButton = UIButton(frame: CGRect(x: 0, y: descriptionView.frame.maxY + 10, width: view.frame.width, height: 30))
        isInterestedButton.layoutIfNeeded()
        isInterestedButton.setTitleColor(UIColor.black, for: .normal)
        isInterestedButton.layer.borderWidth = 2.0
        isInterestedButton.layer.cornerRadius = 3.0
        isInterestedButton.layer.borderColor = UIColor.blue.cgColor
        isInterestedButton.layer.masksToBounds = true
        
        view.addSubview(userLabel)
        view.addSubview(eventLabel)
        view.addSubview(eventImage)
        view.addSubview(numInterestedButton)
        view.addSubview(descriptionView)
        view.addSubview(isInterestedButton)
    }
    
    func getInfo() {
        let userID = selectedPostID
        
        postsRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.userLabel.text = value?["poster"] as? String ?? ""
            self.eventLabel.text = value?["eventName"] as? String ?? ""
            
            if let url = NSURL(string: value?["imageUrl"] as! String) {
                if let data = NSData(contentsOf: url as URL) {
                    self.eventImage.image = UIImage(data: data as Data)
                }
            } else {
                    self.eventImage.image = #imageLiteral(resourceName: "puppy")
            }
            self.numInterestedButton.setTitle("Interested: 0", for: .normal)
            self.descriptionView.text = value?["description"] as? String ?? ""
            self.isInterestedButton.setTitle("Interested", for: .normal)
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}
