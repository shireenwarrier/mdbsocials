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
    var dateView: UIView!
    var monthLabel: UILabel!
    var detailsLabel: UILabel!
    var heartImage: UIImage!
    var dayLabel: UILabel!
    var dateLabel: UILabel!
    var isInterestedButton: UIButton!
    var isInterested = GoingStatus.notResponded
    var auth = FIRAuth.auth()
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    static var selectedPostID: String?
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
        view.backgroundColor = UIColor.white
        
        eventImage = UIImageView(frame: CGRect(x: 0, y: (navigationController?.navigationBar.frame.maxY)!, width: view.frame.width, height: view.frame.height/2))
        eventImage.layoutIfNeeded()
        eventImage.layer.masksToBounds = true
        
        dateView = UIView(frame: CGRect(x: 20, y: eventImage.frame.maxY + 15, width: view.frame.width/6, height: view.frame.width/6))
        dateView.layer.cornerRadius = 5.0
        dateView.layer.masksToBounds = true
        dateView.backgroundColor = Constants.backgroundColor
        
        monthLabel = UILabel(frame: CGRect(x: dateView.frame.minX, y: dateView.frame.minY, width: dateView.frame.width, height: dateView.frame.height/4))
        monthLabel.layoutIfNeeded()
        monthLabel.layer.cornerRadius = 5.0
        monthLabel.layer.masksToBounds = true
        monthLabel.font = UIFont(name: "Apple SD Gothic Neo", size: monthLabel.font.pointSize)
        monthLabel.backgroundColor = Constants.backgroundColor
        monthLabel.textColor = UIColor.white
        monthLabel.textAlignment = .center
        
        dayLabel = UILabel(frame: CGRect(x: dateView.frame.minX, y: monthLabel.frame.maxY, width: dateView.frame.width, height: dateView.frame.height * (3/4)))
        dayLabel.layoutIfNeeded()
        dayLabel.layer.cornerRadius = 5.0
        dayLabel.layer.masksToBounds = true
        dayLabel.backgroundColor = Constants.backgroundColor
        dayLabel.adjustsFontSizeToFitWidth = true
        dayLabel.textColor = UIColor.white
        dayLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 38)
        dayLabel.textAlignment = .center
        
        eventLabel = UILabel(frame: CGRect(x: dateView.frame.maxX + 20, y: dateView.frame.minY, width: view.frame.width/2, height: dateView.frame.height))
        eventLabel.layoutIfNeeded()
        eventLabel.textColor = UIColor.black
        eventLabel.adjustsFontSizeToFitWidth = true
        eventLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 24)
        eventLabel.layer.masksToBounds = true
        
        heartImage = UIImage(named: "heart")!.alpha(0.2)
        isInterestedButton = UIButton(frame: CGRect(x: eventLabel.frame.maxX + 5, y: dateView.frame.minY + dateView.frame.height/3, width: 30, height: 30))
        isInterestedButton.layoutIfNeeded()
        isInterestedButton.setImage(heartImage, for: .normal)
        isInterestedButton.addTarget(self, action: #selector(addInterested), for: .touchUpInside)
        
        userLabel = UILabel(frame: CGRect(x: dateView.frame.minX, y: dateView.frame.maxY + 20, width: view.frame.width - 40, height: 30))
        userLabel.layoutIfNeeded()
        userLabel.font = UIFont(name: "Apple SD Gothic Neo", size: userLabel.font.pointSize)
        userLabel.textColor = UIColor.black
        userLabel.layer.masksToBounds = true
        
        detailsLabel = UILabel(frame: CGRect(x: dateView.frame.minX, y: userLabel.frame.maxY + 10, width: view.frame.width, height: 25))
        detailsLabel.layoutIfNeeded()
        detailsLabel.text = "Details:"
        detailsLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 16)
        detailsLabel.textColor = UIColor.red
        detailsLabel.layer.masksToBounds = true
        
        dateLabel = UILabel(frame: CGRect(x: dateView.frame.minX, y: detailsLabel.frame.maxY, width: view.frame.width, height: 20))
        dateLabel.layoutIfNeeded()
        dateLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        dateLabel.textColor = UIColor.black
        dateLabel.layer.masksToBounds = true
        
        descriptionView = UITextView(frame: CGRect(x: dateView.frame.minX, y: dateLabel.frame.maxY, width: view.frame.width, height: 25))
        descriptionView.isEditable = false
        descriptionView.layoutIfNeeded()
        descriptionView.textColor = UIColor.black
        descriptionView.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        descriptionView.layer.cornerRadius = 3.0
        descriptionView.layer.masksToBounds = true
        
        numInterestedButton = UIButton(frame: CGRect(x: dateView.frame.minX, y: descriptionView.frame.maxY + 10, width: view.frame.width/2, height: 30))
        numInterestedButton.layoutIfNeeded()
        numInterestedButton.backgroundColor = Constants.backgroundColor
        numInterestedButton.setTitleColor(UIColor.white, for: .normal)
        numInterestedButton.titleLabel?.font = UIFont(name: "Apple SD Gothic Neo", size: (numInterestedButton.titleLabel?.font.pointSize)!)
        numInterestedButton.layer.cornerRadius = 3.0
        numInterestedButton.layer.masksToBounds = true
        numInterestedButton.addTarget(self, action: #selector(getInterested), for: .touchUpInside)
        
        view.addSubview(eventImage)
        view.addSubview(dateView)
        view.addSubview(monthLabel)
        view.addSubview(dayLabel)
        view.addSubview(eventLabel)
        view.addSubview(isInterestedButton)
        view.addSubview(userLabel)
        view.addSubview(detailsLabel)
        view.addSubview(dateLabel)
        view.addSubview(descriptionView)
        view.addSubview(numInterestedButton)
    }
    
    func getInfo() {
        let postID = DetailViewController.selectedPostID
        let post = postsRef.child(postID!)
        
        let block: ((FIRDataSnapshot) -> Void) = { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let fullDate = value?["date"] as? String ?? ""
            let indexOne = fullDate.index(fullDate.startIndex, offsetBy: fullDate.index(of: " ")!)
            
            let indexTwo = fullDate.index(fullDate.startIndex, offsetBy: fullDate.index(of: ",")!)
            let indexThree = fullDate.index(fullDate.startIndex, offsetBy: fullDate.index(of: " ")! + 1)
            let range = indexThree..<indexTwo
            
            DispatchQueue.main.async {
                self.monthLabel.text = fullDate.substring(to: indexOne)
                self.dayLabel.text = fullDate.substring(with: range)
                self.userLabel.text = (value?["poster"] as? String ?? "") + " shared this with you"
                self.eventLabel.text = value?["eventName"] as? String ?? ""
                self.dateLabel.text = fullDate

                if let url = NSURL(string: value?["imageUrl"] as! String) {
                    if let data = NSData(contentsOf: url as URL) {
                        self.eventImage.image = UIImage(data: data as Data)
                    }
                } else {
                    self.eventImage.image = #imageLiteral(resourceName: "puppy")
                }
                self.descriptionView.text = value?["description"] as? String ?? ""
                
                let interestedIds = value?["usersInterested"] as? [String] ?? []
                self.numInterestedButton.setTitle("People Going: \(interestedIds.count)", for: .normal)
            }

        }
        
        post.observeSingleEvent(of: .value, with: block)
    }
    
    func getInterested() {
        self.navigationController?.pushViewController(InterestedUsersViewController(), animated: true)
    }
    
    func addInterested() {
        let postID = DetailViewController.selectedPostID
        
        let block: ((FIRDataSnapshot) -> Void) = { (snapshot) in
            // Get user value
            let post = Post(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            post.addInterestedUser(withId: (self.currentUser?.id)!)
            
            DispatchQueue.main.async {
                self.isInterestedButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
                self.isInterestedButton.isEnabled = false
                self.isInterested = GoingStatus.interested
                self.numInterestedButton.setTitle("People Going: \(post.getNumInterestedUsers())", for: .normal)
            }
            // ...
        }
        
        postsRef.child(postID!).observeSingleEvent(of: .value, with: block)

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

extension String {
    public func index(of char: Character) -> Int? {
        if let idx = characters.index(of: char) {
            return characters.distance(from: startIndex, to: idx)
        }
        return nil
    }
}

extension UIImage{
    
    func alpha(_ value:CGFloat)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
}
