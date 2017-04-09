//
//  FeedViewController.swift
//  MDBSocials
//
//  Created by Shireen Warrier on 2/24/17.
//  Copyright © 2017 Shireen Warrier. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {

    var newPostButton: UIButton!
    var postCollectionView: UICollectionView!
    var posts: [Post] = []
    var auth = FIRAuth.auth()
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    var storage: FIRStorageReference = FIRStorage.storage().reference()
    var currentUser: User?
    var selectedPostID: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        self.setupButton()
        
        fetchUser {
            self.fetchPosts() {
                self.setupNavBar()
                self.setupButton()
                self.setupCollectionView()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if postCollectionView != nil {
            DispatchQueue.main.async {
                self.postCollectionView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupNavBar() {
        self.title = "Feed"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
    }
    
    func logOut() {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            
            DispatchQueue.main.async {
                let navigationController = UINavigationController(rootViewController: LoginViewController())
                self.present(navigationController, animated: true)
            }
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    func setupButton() {
        newPostButton = UIButton(frame: CGRect(x: 10, y: view.frame.maxY - 60, width: UIScreen.main.bounds.width - 20, height: 50))
        newPostButton.backgroundColor = Constants.backgroundColor
        newPostButton.setTitle("Create Event", for: .normal)
        newPostButton.titleLabel?.font = UIFont(name: "Apple SD Gothic Neo", size: newPostButton.titleLabel!.font.pointSize)
        newPostButton.setTitleColor(UIColor.white, for: .normal)
        newPostButton.layoutIfNeeded()
        newPostButton.layer.cornerRadius = 3.0
        newPostButton.layer.masksToBounds = true
        newPostButton.addTarget(self, action: #selector(addNewPost), for: .touchUpInside)
        view.addSubview(newPostButton)
    }
    
    func setupCollectionView() {
        let frame = CGRect(x: 0, y: (navigationController?.navigationBar.frame.maxY)! + 10, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - ((UIScreen.main.bounds.height - newPostButton.frame.minY) + 2*(navigationController?.navigationBar.frame.height)! + 20))
        let cvLayout = UICollectionViewFlowLayout()
        cvLayout.minimumLineSpacing = 30
        
        postCollectionView = UICollectionView(frame: frame, collectionViewLayout: cvLayout)
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "post")
        postCollectionView.backgroundColor = UIColor.white

        view.addSubview(postCollectionView)
    }
    
    func addNewPost(sender: UIButton!) {
        self.navigationController?.pushViewController(NewSocialViewController(), animated: true)
    }
    
    func fetchPosts(withBlock: @escaping () -> ()) {
        let ref = FIRDatabase.database().reference()
        
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            let post = Post(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            
            DispatchQueue.main.async {
                self.posts.insert(post, at: 0)
            }
            
            withBlock()
        })
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

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = postCollectionView.dequeueReusableCell(withReuseIdentifier: "post", for: indexPath) as! PostCollectionViewCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        cell.awakeFromNib()
        cell.delegate = self
        
        let postInQuestion = posts[indexPath.row]
        
        cell.usernameLabel.text = "Posted By " + postInQuestion.poster!
        cell.eventNameLabel.text = postInQuestion.eventName
        cell.dateLabel.text = postInQuestion.date
        
        if let url = NSURL(string: postInQuestion.imageUrl! as String) {
            if let data = NSData(contentsOf: url as URL) {
                let image = UIImage(data: data as Data)
                cell.imageView.image = image
            }
        } else {
            let image = #imageLiteral(resourceName: "puppy")
            cell.imageView.image = image
        }
        
        cell.interestedLabel.text = "People Going: \(postInQuestion.getNumInterestedUsers())"
        cell.postID = postInQuestion.id!

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPostID = posts[indexPath.row].id
        DetailViewController.selectedPostID = self.selectedPostID
        self.navigationController?.pushViewController(DetailViewController(), animated: true)
    }

}

extension FeedViewController: PostCollectionViewDelegate {
    func addInterestedUser(forCell: PostCollectionViewCell) {
        forCell.interestedButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        
        let block: ((FIRDataSnapshot) -> Void) = { (snapshot) in
            let post = Post(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            post.addInterestedUser(withId: (self.currentUser?.id)!)
            // ...
        }

        postsRef.child(forCell.postID).observeSingleEvent(of: .value, with: block)
    }
}
