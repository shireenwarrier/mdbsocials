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
    var descriptionField: UITextView!
    var dateField: UITextField!
    var dayField: UITextField!
    var timeField: UITextField!
    var eventImageView: UIImageView!
    var selectImageButton: UIButton!
    var openCameraButton: UIButton!
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
        self.navigationController?.isNavigationBarHidden = true
        
        eventNameField = UITextField(frame: CGRect(x: 10, y: view.frame.minY + 30, width: view.frame.width - 20, height: 40))
        eventNameField.layoutIfNeeded()
        eventNameField.layer.shadowRadius = 2.0
        eventNameField.layer.masksToBounds = true
        eventNameField.placeholder = "Event Name"
        eventNameField.adjustsFontSizeToFitWidth = true
        eventNameField.layer.borderColor = UIColor.lightGray.cgColor
        eventNameField.layer.borderWidth = 1.0
        eventNameField.textColor = UIColor.black
        
        eventImageView = UIImageView(frame: CGRect(x: 10, y: eventNameField.frame.maxY + 20, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.width - 70))
        eventImageView.layer.borderColor = UIColor.lightGray.cgColor
        selectImageButton = UIButton(frame: CGRect(x: eventImageView.frame.minX, y: eventImageView.frame.minY, width: eventImageView.frame.width, height: eventImageView.frame.height/2))
        selectImageButton.setTitle("Pick Image From Library", for: .normal)
        selectImageButton.layer.borderColor = UIColor.lightGray.cgColor
        selectImageButton.setTitleColor(UIColor.blue, for: .normal)
        selectImageButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        openCameraButton = UIButton(frame: CGRect(x: eventImageView.frame.minX, y: selectImageButton.frame.maxY, width: eventImageView.frame.width, height: eventImageView.frame.height/2))
        openCameraButton.setTitle("Open Camera", for: .normal)
        openCameraButton.layer.borderColor = UIColor.lightGray.cgColor
        openCameraButton.setTitleColor(UIColor.blue, for: .normal)
        openCameraButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        
        descriptionField = UITextView(frame: CGRect(x: 10, y: eventImageView.frame.maxY + 20, width: view.frame.width - 20, height: 0.1 * UIScreen.main.bounds.height))
        descriptionField.layoutIfNeeded()
        descriptionField.layer.shadowRadius = 2.0
        descriptionField.layer.masksToBounds = true
        descriptionField.text = "Description"
        descriptionField.font = UIFont(name: "ArialMT", size: 18)
        descriptionField.textContainer.maximumNumberOfLines = 2
        descriptionField.layer.borderColor = UIColor.lightGray.cgColor
        descriptionField.layer.borderWidth = 1.0
        descriptionField.textColor = UIColor.black
        descriptionField.isUserInteractionEnabled = true
        descriptionField.delegate = self
        
        dateField = UITextField(frame: CGRect(x: 10, y: descriptionField.frame.maxY + 30, width: view.frame.width - 20, height: 30))
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
        view.addSubview(openCameraButton)
        view.bringSubview(toFront: selectImageButton)
        view.bringSubview(toFront: openCameraButton)
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
            let newPost = ["eventName": eventName, "firstName": self.currentUser?.firstName!, "lastName": self.currentUser?.lastName!, "description": description, "numLikes": 0, "posterId": self.currentUser?.id!, "poster": (self.currentUser?.firstName)! + " " + (self.currentUser?.lastName)!, "imageUrl": url, "date": date, "day": day, "time": time, "usersInterested": []] as [String : Any]
            let key = self.postsRef.childByAutoId().key
            let childUpdates = ["/\(key)/": newPost]
            self.postsRef.updateChildValues(childUpdates)
            self.performSegue(withIdentifier: "toFeedFromNewSocialView", sender: self)
            self.navigationController?.isNavigationBarHidden = false

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
    
    func openCamera(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }}
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
}

extension NewSocialViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        selectImageButton.removeFromSuperview()
        openCameraButton.removeFromSuperview()
        
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            eventImageView.contentMode = .scaleAspectFit
            eventImageView.image = chosenImage
        } else {
            print("Image picker error")
        }
        
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        descriptionField.text = ""
    }
}
