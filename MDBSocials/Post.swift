//
//  Post.swift
//  MDBSocials
//
//  Created by Shireen Warrier on 2/24/17.
//  Copyright © 2017 Shireen Warrier. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Post {
    var eventName: String?
    var firstName: String?
    var lastName: String?
    var description: String?
    var numLikes: Int?
    var posterId: String?
    var poster: String?
    var id: String?
    var imageUrl: String? = "http://cdn2-www.dogtime.com/assets/uploads/gallery/30-impossibly-cute-puppies/impossibly-cute-puppy-8.jpg"
    var date: String?
    var usersInterested: [String] = []
    let postRef = FIRDatabase.database().reference().child("Posts")
    
    init(id: String, postDict: [String: Any]?) {
        self.id = id
        if postDict != nil {
            if let eventName = postDict!["eventName"] as? String {
                self.eventName = eventName
            }
            if let firstName = postDict!["firstName"] as? String {
                self.firstName = firstName
            }
            if let lastName = postDict!["lastName"] as? String {
                self.lastName = lastName
            }
            if let description = postDict!["description"] as? String {
                self.description = description
            }
            if let date = postDict!["date"] as? String {
                self.date = date
            }
            if let numLikes = postDict!["numLikes"] as? Int {
                self.numLikes = numLikes
            }
            if let posterId = postDict!["posterId"] as? String {
                self.posterId = posterId
            }
            if let poster = postDict!["poster"] as? String {
                self.poster = poster
            }
            if let imageUrl = postDict!["imageUrl"] as? String {
                self.imageUrl = imageUrl
            }
            if let usersInterested = postDict!["usersInterested"] as? [String] {
                self.usersInterested = usersInterested
            }
            
        }
    }
    
    func getNumInterestedUsers() -> Int {
        return usersInterested.count
    }
    
    func addInterestedUser(withId: String) {
        if !self.usersInterested.contains(withId) {
            self.usersInterested.append(withId)
            let childUpdates = ["\(self.id!)/usersInterested": self.usersInterested]
            postRef.updateChildValues(childUpdates)
        }
    }
}


