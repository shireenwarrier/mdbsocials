//
//  NewSocialViewController.swift
//  MDBSocials
//
//  Created by Shireen Warrier on 2/25/17.
//  Copyright © 2017 Shireen Warrier. All rights reserved.
//

import UIKit
import Firebase

class NewSocialViewController: UIViewController {
    var eventNameField: UITextField!
    let picker = UIImagePickerController()
    var descriptionField: UITextField!
    var dateField: UITextField!
    var dayField: UITextField!
    var timeField: UITextField!
    var eventImageView: UIImageView!
    var selectImageButton: UIButton!
    var addEventButton: UIButton!
    var auth = FIRAuth.auth()
    var postsRef: FIRDatabaseReference = FIRDatabase.database().reference().child("Posts")
    var storage: FIRStorageReference = FIRStorage.storage().reference()
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser {
            self.picker.delegate = self
            self.setupUI()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        eventNameField = UITextField(frame: CGRect(x: 10, y: navigationController!.navigationBar.frame.maxY, width: view.frame.width - 20, height: 30))
        eventNameField.layoutIfNeeded()
        eventNameField.layer.shadowRadius = 2.0
        eventNameField.layer.masksToBounds = true
        eventNameField.placeholder = "Event Name"
        eventNameField.adjustsFontSizeToFitWidth = true
        eventNameField.layer.borderColor = UIColor.lightGray.cgColor
        eventNameField.layer.borderWidth = 1.0
        eventNameField.textColor = UIColor.black
        
        eventImageView = UIImageView(frame: CGRect(x: 10, y: eventNameField.frame.maxY + 10, width: UIScreen.main.bounds.width - 70, height: UIScreen.main.bounds.width - 70))
        selectImageButton = UIButton(frame: eventImageView.frame)
        selectImageButton.setTitle("Pick Image From Library", for: .normal)
        selectImageButton.setTitleColor(UIColor.blue, for: .normal)
        selectImageButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        
        descriptionField = UITextField(frame: CGRect(x: 10, y: eventImageView.frame.maxY + 10, width: view.frame.width - 20, height: 0.2 * UIScreen.main.bounds.height))
        descriptionField.layoutIfNeeded()
        descriptionField.layer.shadowRadius = 2.0
        descriptionField.layer.masksToBounds = true
        descriptionField.placeholder = "Description"
        descriptionField.adjustsFontSizeToFitWidth = true
        descriptionField.layer.borderColor = UIColor.lightGray.cgColor
        descriptionField.layer.borderWidth = 1.0
        descriptionField.textColor = UIColor.black
        
        dateField = UITextField(frame: CGRect(x: 10, y: descriptionField.frame.maxY + 10, width: view.frame.width - 20, height: 30))
        dateField.layoutIfNeeded()
        dateField.layer.shadowRadius = 2.0
        dateField.layer.masksToBounds = true
        dateField.placeholder = "Date (MM/DD/YY)"
        dateField.adjustsFontSizeToFitWidth = true
        dateField.layer.borderColor = UIColor.lightGray.cgColor
        dateField.layer.borderWidth = 1.0
        dateField.textColor = UIColor.black
        
        dayField = UITextField(frame: CGRect(x: 10, y: dateField.frame.maxY + 10, width: view.frame.width * (1/2) - 5, height: 30))
        dayField.layoutIfNeeded()
        dayField.layer.shadowRadius = 2.0
        dayField.layer.masksToBounds = true
        dayField.placeholder = "Day (Write out fully)"
        dayField.adjustsFontSizeToFitWidth = true
        dayField.layer.borderColor = UIColor.lightGray.cgColor
        dayField.layer.borderWidth = 1.0
        dayField.textColor = UIColor.black
        
        timeField = UITextField(frame: CGRect(x: dayField.frame.maxX + 10, y: dateField.frame.maxY + 10, width: (view.frame.width * (1/2)) - 25, height: 30))
        timeField.layoutIfNeeded()
        timeField.layer.shadowRadius = 2.0
        timeField.layer.masksToBounds = true
        timeField.placeholder = "Time (00:00)"
        timeField.adjustsFontSizeToFitWidth = true
        timeField.layer.borderColor = UIColor.lightGray.cgColor
        timeField.layer.borderWidth = 1.0
        timeField.textColor = UIColor.black
        
        addEventButton = UIButton(frame: CGRect(x: 10, y: timeField.frame.maxY + 10, width: view.frame.width - 20, height: 30))
        addEventButton.setTitle("Add New Event", for: .normal)
        addEventButton.setTitleColor(UIColor.blue, for: .normal)
        addEventButton.addTarget(self, action: #selector(addNewEvent), for: .touchUpInside)
        
        view.addSubview(eventNameField)
        view.addSubview(descriptionField)
        view.addSubview(dateField)
        view.addSubview(dayField)
        view.addSubview(timeField)
        view.addSubview(addEventButton)
        view.addSubview(eventImageView)
        view.addSubview(selectImageButton)
        view.bringSubview(toFront: selectImageButton)
    }

    func addNewEvent() {
        let description = descriptionField.text!
        self.descriptionField.text = ""
        let eventName = eventNameField.text!
        self.eventNameField.text = ""
        let date = dateField.text!
        self.dateField.text = ""
        let day = dayField.text!
        self.dayField.text = ""
        let time = timeField.text!
        self.timeField.text = ""
        
        let eventImageData = UIImageJPEGRepresentation(eventImageView.image!, 0.9)
        let storage = FIRStorage.storage().reference().child("eventpics/\((currentUser?.id)!)")
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        storage.put(eventImageData!, metadata: metadata).observe(.success) { (snapshot) in
            let url = snapshot.metadata?.downloadURL()?.absoluteString
            let newPost = ["eventName": eventName, "firstName": self.currentUser?.firstName!, "lastName": self.currentUser?.lastName!, "description": description, "numLikes": 0, "posterId": self.currentUser?.id!, "poster": (self.currentUser?.firstName)! + " " + (self.currentUser?.lastName)!, "imageUrl": url, "date": date, "day": day, "time": time] as [String : Any]
            let key = self.postsRef.childByAutoId().key
            let childUpdates = ["/\(key)/": newPost]
            self.postsRef.updateChildValues(childUpdates)
            self.performSegue(withIdentifier: "toFeedFromNewSocialView", sender: self)
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
    
    func pickImage(sender: UIButton!) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
}

extension NewSocialViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        selectImageButton.removeFromSuperview()
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        eventImageView.contentMode = .scaleAspectFit
        eventImageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
