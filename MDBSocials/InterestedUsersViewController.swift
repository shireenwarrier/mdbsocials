//
//  InterestedUsersViewController.swift
//  MDBSocials
//
//  Created by Shireen Warrier on 3/2/17.
//  Copyright © 2017 Shireen Warrier. All rights reserved.
//

import UIKit
import Firebase

class InterestedUsersViewController: UIViewController {
    var interestedUsers: [String]? = []
    var tableView: UITableView!
    var usersRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Users")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchInterestedUsers() {
            self.setupTableView()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupTableView(){
        //Initialize TableView Object here
        tableView = UITableView(frame: CGRect(x: 0, y: 40, width: view.frame.width, height: view.frame.height))
        
        //Register the tableViewCell you are using
        tableView.register(InterestedUsersTableViewCell.self, forCellReuseIdentifier: "userCell")
        
        //Set properties of TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 50/2, right: 0)
        
        //Add tableView to view
        view.addSubview(tableView)
    }
    
    func fetchInterestedUsers(withBlock: @escaping () -> ()) {
        self.navigationController?.navigationBar.isHidden = false
        
        let ref = FIRDatabase.database().reference()
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            let post = Post(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            self.interestedUsers = post.usersInterested
            
            withBlock()
        })
    }
    
}

extension InterestedUsersViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interestedUsers!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! InterestedUsersTableViewCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        
        let userInQuestion = interestedUsers![indexPath.row]
        
        usersRef.child(userInQuestion).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            cell.userLabel.text = (value?["firstName"] as? String ?? "") + " " + (value?["lastName"] as? String ?? "")
            cell.userLabel.adjustsFontSizeToFitWidth = true
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        return cell
    }
    
}
