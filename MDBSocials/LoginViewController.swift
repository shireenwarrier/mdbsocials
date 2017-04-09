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
    var appLabel: UILabel!
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
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = Constants.backgroundColor
        
        appLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 150))
        appLabel.textAlignment = .center
        appLabel.text = "MDB Socials"
        appLabel.textColor = UIColor.white
        appLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 35)
        appLabel.adjustsFontSizeToFitWidth = true

        emailField = UITextField(frame: CGRect(x: view.frame.width/4, y: view.frame.height/3, width: view.frame.width/2, height: 50))
        emailField.adjustsFontSizeToFitWidth = true
        emailField.placeholder = "   Email"
        emailField.layoutIfNeeded()
        emailField.layer.borderColor = UIColor.white.cgColor
        emailField.layer.borderWidth = 3.0
        emailField.layer.masksToBounds = true
        emailField.textColor = UIColor.white
        emailField.autocapitalizationType = .none
        
        passwordField = UITextField(frame: CGRect(x: view.frame.width/4, y: emailField.frame.maxY + 30, width: view.frame.width/2, height: 50))
        passwordField.adjustsFontSizeToFitWidth = true
        passwordField.placeholder = "   Password"
        passwordField.layoutIfNeeded()
        passwordField.layer.borderColor = UIColor.white.cgColor
        passwordField.layer.borderWidth = 3.0
        passwordField.isSecureTextEntry = true
        passwordField.layer.masksToBounds = true
        passwordField.textColor = UIColor.white

        signupButton = UIButton(frame: CGRect(x: view.frame.width/4, y: view.frame.height * (3/4), width: view.frame.width/4 - 5, height: 50))
        signupButton.layoutIfNeeded()
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.setTitleColor(UIColor.white, for: .normal)
        signupButton.layer.borderWidth = 3.0
        signupButton.layer.cornerRadius = 3.0
        signupButton.layer.borderColor = UIColor.white.cgColor
        signupButton.layer.masksToBounds = true
        signupButton.addTarget(self, action: #selector(signup), for: .touchUpInside)
        
        loginButton = UIButton(frame: CGRect(x: view.frame.width/2 + 5, y: view.frame.height * (3/4), width: view.frame.width/4 - 5, height: 50))
        loginButton.layoutIfNeeded()
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.layer.borderWidth = 3.0
        loginButton.layer.cornerRadius = 3.0
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        view.addSubview(appLabel)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signupButton)
        view.addSubview(loginButton)
    }

    func signup() {
        self.navigationController?.pushViewController(SignupViewController(), animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func login() {
        let email = emailField.text!
        let password = passwordField.text!
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error == nil {
                let navigationController = UINavigationController(rootViewController: FeedViewController())
                self.present(navigationController, animated: true)
            }
        })
    }
    
}
