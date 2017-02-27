//
//  LoginViewController.swift
//  MDBSocials
//
//  Created by Shireen Warrier on 2/24/17.
//  Copyright © 2017 Shireen Warrier. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    var emailField: UITextField!
    var passwordField: UITextField!
    var signupButton: UIButton!
    var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func setupUI() {
        emailField = UITextField(frame: CGRect(x: view.frame.width/3, y: view.frame.height/3, width: view.frame.width/3, height: 50))
        emailField.adjustsFontSizeToFitWidth = true
        emailField.placeholder = "Email"
        emailField.layoutIfNeeded()
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        emailField.layer.borderWidth = 1.0
        emailField.layer.masksToBounds = true
        emailField.textColor = UIColor.black        
        
        passwordField = UITextField(frame: CGRect(x: view.frame.width/3, y: emailField.frame.maxY, width: view.frame.width/3, height: 50))
        passwordField.adjustsFontSizeToFitWidth = true
        passwordField.placeholder = "Password"
        passwordField.layoutIfNeeded()
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        passwordField.layer.borderWidth = 1.0
        passwordField.isSecureTextEntry = true
        passwordField.layer.masksToBounds = true
        passwordField.textColor = UIColor.black

        signupButton = UIButton(frame: CGRect(x: view.frame.width/4, y: view.frame.height * (3/4), width: view.frame.width/4 - 5, height: 50))
        signupButton.layoutIfNeeded()
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.setTitleColor(UIColor.blue, for: .normal)
        signupButton.layer.borderWidth = 2.0
        signupButton.layer.cornerRadius = 3.0
        signupButton.layer.borderColor = UIColor.blue.cgColor
        signupButton.layer.masksToBounds = true
        signupButton.addTarget(self, action: #selector(signup), for: .touchUpInside)
        
        loginButton = UIButton(frame: CGRect(x: view.frame.width/2 + 5, y: view.frame.height * (3/4), width: view.frame.width/4 - 5, height: 50))
        loginButton.layoutIfNeeded()
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(UIColor.blue, for: .normal)
        loginButton.layer.borderWidth = 2.0
        loginButton.layer.cornerRadius = 3.0
        loginButton.layer.borderColor = UIColor.blue.cgColor
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signupButton)
        view.addSubview(loginButton)
    }

    func signup() {
        performSegue(withIdentifier: "segueToSignup", sender: self)
    }
    
    func login() {
        let email = emailField.text!
        let password = passwordField.text!
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error == nil {
                self.performSegue(withIdentifier: "segueLoginToFeed", sender: self)
            }
        })
    }
    
}
