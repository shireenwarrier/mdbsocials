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
    var interestedLabel: UILabel!
    var isInterested = GoingStatus.notResponded
    var auth = FIRAuth.auth()
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    var selectedPostID: String?
    var currentUser: User?
    
    enum GoingStatus {
        case interested, notResponded
    }

    override func viewDidLoad() {
        fetchUser {
            self.setupUI()
            self.getInfo()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        userLabel = UILabel(frame: CGRect(x: 20, y: 80, width: view.frame.width - 40, height: 30))
        userLabel.layoutIfNeeded()
        userLabel.textColor = UIColor.black
        userLabel.layer.borderWidth = 2.0
        userLabel.layer.cornerRadius = 3.0
        userLabel.layer.borderColor = Constants.feedBorderColor
        userLabel.layer.masksToBounds = true
        
        eventLabel = UILabel(frame: CGRect(x: 20, y: userLabel.frame.maxY + 10, width: view.frame.width - 40, height: 30))
        eventLabel.layoutIfNeeded()
        eventLabel.textColor = UIColor.black
        eventLabel.layer.borderWidth = 2.0
        eventLabel.layer.cornerRadius = 3.0
        eventLabel.layer.borderColor = Constants.feedBorderColor
        eventLabel.layer.masksToBounds = true
        
        eventImage = UIImageView(frame: CGRect(x: 0, y: eventLabel.frame.maxY + 10, width: view.frame.width, height: 350))
        eventImage.layoutIfNeeded()
        eventImage.layer.borderWidth = 2.0
        eventImage.layer.cornerRadius = 3.0
        eventImage.layer.borderColor = Constants.feedBorderColor
        eventImage.layer.masksToBounds = true
        
        numInterestedButton = UIButton(frame: CGRect(x: 0, y: eventImage.frame.maxY + 10, width: view.frame.width, height: 30))
        numInterestedButton.layoutIfNeeded()
        numInterestedButton.setTitleColor(UIColor.black, for: .normal)
        numInterestedButton.layer.borderWidth = 2.0
        numInterestedButton.layer.cornerRadius = 3.0
        numInterestedButton.layer.borderColor = Constants.feedBorderColor
        numInterestedButton.layer.masksToBounds = true
        numInterestedButton.addTarget(self, action: #selector(getInterested), for: .touchUpInside)
        
        descriptionView = UITextView(frame: CGRect(x: 0, y: numInterestedButton.frame.maxY + 10, width: view.frame.width, height: 100))
        descriptionView.isEditable = false
        descriptionView.layoutIfNeeded()
        descriptionView.textColor = UIColor.black
        descriptionView.layer.borderWidth = 2.0
        descriptionView.layer.cornerRadius = 3.0
        descriptionView.layer.borderColor = Constants.feedBorderColor
        descriptionView.layer.masksToBounds = true
        descriptionView.font = UIFont(name: "ArialMT", size: 18)
        
        interestedLabel = UILabel(frame: CGRect(x: view.frame.width/4, y: descriptionView.frame.maxY + 10, width: view.frame.width/4, height: 30))
        interestedLabel.layoutIfNeeded()
        interestedLabel.textColor = UIColor.black
        interestedLabel.layer.borderWidth = 2.0
        interestedLabel.layer.cornerRadius = 3.0
        interestedLabel.layer.borderColor = Constants.feedBorderColor
        interestedLabel.layer.masksToBounds = true
        
        isInterestedButton = UIButton(frame: CGRect(x: interestedLabel.frame.maxX + 10, y: descriptionView.frame.maxY + 10, width: 40, height: 30))
        isInterestedButton.layoutIfNeeded()
        isInterestedButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        isInterestedButton.layer.borderWidth = 2.0
        isInterestedButton.layer.cornerRadius = 3.0
        isInterestedButton.layer.borderColor = Constants.feedBorderColor
        isInterestedButton.layer.masksToBounds = true
        isInterestedButton.addTarget(self, action: #selector(addInterested), for: .touchUpInside)
        
        view.addSubview(userLabel)
        view.addSubview(eventLabel)
        view.addSubview(eventImage)
        view.addSubview(numInterestedButton)
        view.addSubview(descriptionView)
        view.addSubview(interestedLabel)
        view.addSubview(isInterestedButton)
    }
    
    func getInfo() {
        let postID = selectedPostID
        let post = postsRef.child(postID!)
        
        post.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.userLabel.text = value?["poster"] as? String ?? ""
            self.eventLabel.text = value?["eventName"] as? String ?? ""
            self.interestedLabel.text = "Interested"
            
            if let url = NSURL(string: value?["imageUrl"] as! String) {
                if let data = NSData(contentsOf: url as URL) {
                    self.eventImage.image = UIImage(data: data as Data)
                }
            } else {
                    self.eventImage.image = #imageLiteral(resourceName: "puppy")
            }
            self.descriptionView.text = value?["description"] as? String ?? ""
            
            let interestedIds = value?["usersInterested"] as? [String] ?? []
            self.numInterestedButton.setTitle("Interested: \(interestedIds.count)", for: .normal)

            if interestedIds.index(of: (self.auth?.currentUser?.uid)!) != nil {
                self.isInterestedButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
                self.isInterestedButton.isEnabled = false
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getInterested() {
        self.performSegue(withIdentifier: "segueToInterestedUsers", sender: self)
    }
    
    func addInterested() {
        let postID = selectedPostID
        
        postsRef.child(postID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let post = Post(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            post.addInterestedUser(withId: (self.currentUser?.id)!)
            
            DispatchQueue.main.async {
                self.isInterestedButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
                self.isInterestedButton.isEnabled = false
                self.isInterested = GoingStatus.interested
                self.numInterestedButton.setTitle("Interested: \(post.getNumInterestedUsers() + 1)", for: .normal)
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }

        
    }
    
    func fetchUser(withBlock: @escaping () -> ()) {
        let ref = FIRDatabase.database().reference()
        ref.child("Users").child((self.auth?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let user = User(id: snapshot.key, userDict: snapshot.value as! [String : Any]?)
            self.currentUser = user
            
            withBlock()
        })
    }
    
}
