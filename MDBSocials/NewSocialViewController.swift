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
    var datePicker: UIDatePicker!
    var date: String!
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
        view.backgroundColor = Constants.backgroundColor
        
        eventNameField = UITextField(frame: CGRect(x: 10, y: (navigationController?.navigationBar.frame.maxY)! + 10, width: view.frame.width - 20, height: 40))
        eventNameField.layoutIfNeeded()
        eventNameField.font = UIFont(name: "Apple SD Gothic Neo", size: (eventNameField.font?.pointSize)!)
        eventNameField.layer.shadowRadius = 2.0
        eventNameField.layer.masksToBounds = true
        eventNameField.placeholder = "   Event Name"
        eventNameField.adjustsFontSizeToFitWidth = true
        eventNameField.layer.borderColor = UIColor.white.cgColor
        eventNameField.layer.borderWidth = 3.0
        eventNameField.textColor = UIColor.white
        
        eventImageView = UIImageView(frame: CGRect(x: 10, y: eventNameField.frame.maxY + 20, width: UIScreen.main.bounds.width - 20, height: 200))
        eventImageView.layer.borderColor = UIColor.white.cgColor
        selectImageButton = UIButton(frame: CGRect(x: eventImageView.frame.minX, y: eventImageView.frame.minY, width: eventImageView.frame.width, height: eventImageView.frame.height/2))
        selectImageButton.setTitle("Pick Image From Library", for: .normal)
        selectImageButton.layer.borderColor = UIColor.white.cgColor
        selectImageButton.setTitleColor(UIColor.white, for: .normal)
        selectImageButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        openCameraButton = UIButton(frame: CGRect(x: eventImageView.frame.minX, y: selectImageButton.frame.maxY, width: eventImageView.frame.width, height: eventImageView.frame.height/2))
        openCameraButton.setTitle("Open Camera", for: .normal)
        openCameraButton.layer.borderColor = UIColor.white.cgColor
        openCameraButton.setTitleColor(UIColor.white, for: .normal)
        openCameraButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        
        descriptionField = UITextView(frame: CGRect(x: 10, y: eventImageView.frame.maxY + 20, width: view.frame.width - 20, height: 0.1 * UIScreen.main.bounds.height))
        descriptionField.layoutIfNeeded()
        descriptionField.backgroundColor = Constants.backgroundColor
        descriptionField.layer.shadowRadius = 2.0
        descriptionField.layer.masksToBounds = true
        descriptionField.text = "Description"
        descriptionField.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        descriptionField.textContainer.maximumNumberOfLines = 2
        descriptionField.layer.borderColor = UIColor.white.cgColor
        descriptionField.layer.borderWidth = 3.0
        descriptionField.textColor = UIColor.white
        descriptionField.isUserInteractionEnabled = true
        descriptionField.delegate = self
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: descriptionField.frame.maxY + 20, width: view.frame.width, height: 125))
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.addTarget(self, action: #selector(getDate), for: .valueChanged)
        
        addEventButton = UIButton(frame: CGRect(x: 10, y: datePicker.frame.maxY + 10, width: view.frame.width - 20, height: 30))
        addEventButton.setTitle("Add New Event", for: .normal)
        addEventButton.titleLabel?.font = UIFont(name: "Apple SD Gothic Neo", size: (addEventButton.titleLabel?.font.pointSize)!)
        addEventButton.setTitleColor(UIColor.white, for: .normal)
        addEventButton.addTarget(self, action: #selector(addNewEvent), for: .touchUpInside)
        
        view.addSubview(eventNameField)
        view.addSubview(descriptionField)
        view.addSubview(datePicker)
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
        
        let eventImageData = UIImageJPEGRepresentation(eventImageView.image!, 0.9)
        let storage = FIRStorage.storage().reference().child("eventpics/\((postsRef.childByAutoId().key))")

        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        storage.put(eventImageData!, metadata: metadata).observe(.success) { (snapshot) in
            let url = snapshot.metadata?.downloadURL()?.absoluteString
            let newPost = ["eventName": eventName, "firstName": self.currentUser?.firstName!, "lastName": self.currentUser?.lastName!, "description": description, "numLikes": 0, "posterId": self.currentUser?.id!, "poster": (self.currentUser?.firstName)! + " " + (self.currentUser?.lastName)!, "imageUrl": url, "date": self.date, "usersInterested": []] as [String : Any]
            let key = self.postsRef.childByAutoId().key
            let childUpdates = ["/\(key)/": newPost]
            
            DispatchQueue.main.async {
                self.postsRef.updateChildValues(childUpdates)
                let navigationController = UINavigationController(rootViewController: FeedViewController())
                self.present(navigationController, animated: true)
            }
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
    
    func getDate(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        date = dateFormatter.string(from: sender.date)
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

