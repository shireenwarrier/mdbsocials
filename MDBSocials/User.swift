//
//  User.swift
//  MDBSocials
//
//  Created by Shireen Warrier on 2/24/17.
//  Copyright © 2017 Shireen Warrier. All rights reserved.
//

import Foundation
import UIKit

class User {
    var firstName: String?
    var lastName: String?
    var username: String?
    var password: String?
    var email: String?
    var id: String?
    
    init(id: String, userDict: [String:Any]?) {
        self.id = id
        if userDict != nil {
            if let firstName = userDict!["firstName"] as? String {
                self.firstName = firstName
            }
            if let lastName = userDict!["lastName"] as? String {
                self.lastName = lastName
            }
            if let username = userDict!["username"] as? String {
                self.username = username
            }
            if let password = userDict!["password"] as? String {
                self.password = password
            }
            if let email = userDict!["email"] as? String {
                self.email = email
            }
            
        }
    }
    
    
}
