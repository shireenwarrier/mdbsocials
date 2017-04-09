//
//  SignupViewController.swift
//  MDBSocials
//
//  Created by Shireen Warrier on 2/24/17.
//  Copyright © 2017 Shireen Warrier. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {
    var firstNameField: UITextField!
    var lastNameField: UITextField!
    var userNameField: UITextField!
    var passwordField: UITextField!
    var emailField: UITextField!
    var signupButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController) {
            navigationController?.navigationBar.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        
        firstNameField = UITextField(frame: CGRect(x: view.frame.width/8, y: view.frame.height/4, width: view.frame.width * (3/8) - 10, height: 50))
        firstNameField.adjustsFontSizeToFitWidth = true
        firstNameField.placeholder = "   First Name"
        firstNameField.layoutIfNeeded()
        firstNameField.layer.borderColor = UIColor.white.cgColor
        firstNameField.layer.borderWidth = 3.0
        firstNameField.layer.masksToBounds = true
        firstNameField.textColor = UIColor.white
        firstNameField.autocapitalizationType = .none
        
        lastNameField = UITextField(frame: CGRect(x: firstNameField.frame.maxX + 20, y: view.frame.height/4, width: view.frame.width * (3/8) - 10, height: 50))
        lastNameField.adjustsFontSizeToFitWidth = true
        lastNameField.placeholder = "   Last Name"
        lastNameField.layoutIfNeeded()
        lastNameField.layer.borderColor = UIColor.white.cgColor
        lastNameField.layer.borderWidth = 3.0
        lastNameField.layer.masksToBounds = true
        lastNameField.textColor = UIColor.white
        lastNameField.autocapitalizationType = .none
        
        userNameField = UITextField(frame: CGRect(x: view.frame.width/3, y: lastNameField.frame.maxY + 20, width: view.frame.width/3, height: 50))
        userNameField.adjustsFontSizeToFitWidth = true
        userNameField.placeholder = "   Username"
        userNameField.layoutIfNeeded()
        userNameField.layer.borderColor = UIColor.white.cgColor
        userNameField.layer.borderWidth = 3.0
        userNameField.layer.masksToBounds = true
        userNameField.textColor = UIColor.white
        userNameField.autocapitalizationType = .none
        
        passwordField = UITextField(frame: CGRect(x: view.frame.width/3, y: userNameField.frame.maxY + 20, width: view.frame.width/3, height: 50))
        passwordField.adjustsFontSizeToFitWidth = true
        passwordField.placeholder = "   Enter Password"
        passwordField.isSecureTextEntry = true
        passwordField.layoutIfNeeded()
        passwordField.layer.borderColor = UIColor.white.cgColor
        passwordField.layer.borderWidth = 3.0
        passwordField.layer.masksToBounds = true
        passwordField.textColor = UIColor.white
        
        emailField = UITextField(frame: CGRect(x: view.frame.width/3, y: passwordField.frame.maxY + 20, width: view.frame.width/3, height: 50))
        emailField.adjustsFontSizeToFitWidth = true
        emailField.placeholder = "   Email"
        emailField.layoutIfNeeded()
        emailField.layer.borderColor = UIColor.white.cgColor
        emailField.layer.borderWidth = 3.0
        emailField.layer.masksToBounds = true
        emailField.textColor = UIColor.white
        emailField.autocapitalizationType = .none
        
        signupButton = UIButton(frame: CGRect(x: view.frame.width/3, y: emailField.frame.maxY + 20, width: view.frame.width/3, height: 50))
        signupButton.layoutIfNeeded()
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.setTitleColor(UIColor.white, for: .normal)
        signupButton.layer.borderWidth = 3.0
        signupButton.layer.cornerRadius = 3.0
        signupButton.layer.borderColor = UIColor.white.cgColor
        signupButton.layer.masksToBounds = true
        signupButton.addTarget(self, action: #selector(signup), for: .touchUpInside)
        
        view.addSubview(firstNameField)
        view.addSubview(lastNameField)
        view.addSubview(userNameField)
        view.addSubview(passwordField)
        view.addSubview(emailField)
        view.addSubview(signupButton)
    }
    
    func signup() {
        let firstName = firstNameField.text!
        let lastName = lastNameField.text!
        let username = userNameField.text!
        let password = passwordField.text!
        let email = emailField.text!
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error == nil {
                let ref = FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()?.currentUser?.uid)!)
                
                let block: ((FIRDataSnapshot) -> Void) = { (snapshot) in
                    ref.setValue(["firstName": firstName, "lastName": lastName, "username": username, "password": password, "email": email])
                    self.firstNameField.text = ""
                    self.lastNameField.text = ""
                    self.userNameField.text = ""
                    self.passwordField.text = ""
                    self.emailField.text = ""
                    print("hi")
                    self.present(FeedViewController(), animated: true)
                }
                
                ref.observeSingleEvent(of: .value, with: block)
                
            }
            else {
                print(error.debugDescription)
            }
        })
    }
    
}
