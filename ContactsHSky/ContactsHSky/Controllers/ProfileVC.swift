//
//  ViewController.swift
//  ContactsHSky
//
//  Created by RAG on 22/06/2019.
//  Copyright © 2019 RAG. All rights reserved.
//

import UIKit
import Contacts

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Properties
    
    private var firstNameString = String()
    private var lastNameString = String()
    private var phoneNumberString = String()
    private var profileUserImage = UIImage()
    
    
    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var surnameTxtField: UITextField!
    @IBOutlet weak var phoneNumTxtFld: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rounded Profile Img
        self.profileImageView.layer.borderWidth = 2
        self.profileImageView.layer.borderColor = UIColor.blue.cgColor
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        
        // Add Tap to ProfileImageView
        self.profileImageView.isUserInteractionEnabled = true
        let imageTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.changeImage(recognizer:)))
        imageTap.numberOfTapsRequired = 1
        self.profileImageView.addGestureRecognizer(imageTap)
        
        setupProfileVC()
        self.hideKeyboardWhenTappedAround()
        
    }

    // MARK: - IB Actions
    @IBAction func cancelTapped(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func saveTap(_ sender: Any) {
        
        if ((nameTxtFld.text != "" || surnameTxtField.text != "") && isPhoneNumberValid(phoneNumTxtFld.text!)) {
        
        createContact(nameTxtFld.text ?? "", lastName: surnameTxtField.text ?? "", phone: phoneNumTxtFld.text ?? "", image: profileUserImage)
        
        // create the alert
        let alert = UIAlertController(title: "Success", message: "Profile has been saved.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            self.navigationController?.popToRootViewController(animated: true)
            }))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Profile has not been saved.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Set Up Profile VC
    func initProfileView(firstName: String = "", lastName: String = "", profileImage: UIImage = UIImage(named: "personPlaceholder")!, phoneNumber: String = "", profileType: ProfileTypeEnum) {
        
        switch profileType {
        case .createNew:
            self.profileUserImage = profileImage
            
        case .edit:
            self.profileUserImage = profileImage
            self.firstNameString = firstName
            self.lastNameString = lastName
            self.phoneNumberString = phoneNumber
        }
    }
    
    private func setupProfileVC() {
        
        nameTxtFld.text = "\(firstNameString)"
        surnameTxtField.text = "\(lastNameString)"
        phoneNumTxtFld.text = "\(phoneNumberString)"
        profileImageView.image = UIImage(named: "personPlaceholder")!
        
    }
    
    // MARK: - Create new Contact
    func createContact (_ firstName: String, lastName: String, phone: String?, image: UIImage?){
        // create contact with mandatory values: first and last name
        let newContact = CNMutableContact()
        newContact.givenName = firstName
        newContact.familyName = lastName
        
        // phone
        if phone != nil {
            let contactPhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: phone!))
            newContact.phoneNumbers = [contactPhone]
        }
        
        // image
        if image != nil {
            newContact.imageData = image!.jpegData(compressionQuality: 0.9)
        }
        
        do {
            let newContactRequest = CNSaveRequest()
            newContactRequest.add(newContact, toContainerWithIdentifier: nil)
            try CNContactStore().execute(newContactRequest)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        } catch {
            let alert = UIAlertController(title: "Error creating profile", message: "Unable to create the new contact. An error occurred.", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil ))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - ImagePicker
    @objc func changeImage(recognizer: UIGestureRecognizer) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] {
            selectedImageFromPicker = editedImage as? UIImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] {
            selectedImageFromPicker = originalImage as? UIImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Misc Fncts
    // For pressing return on the keyboard to dismiss keyboard
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        if textField == nameTxtFld {
//            textField.resignFirstResponder()
//            surnameTxtField.becomeFirstResponder()
//        } else if textField == surnameTxtField {
//            textField.resignFirstResponder()
//            phoneNumTxtFld.becomeFirstResponder()
//        } else if textField == phoneNumTxtFld {
//            textField.resignFirstResponder()
//        }
//        return true
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func isPhoneNumberValid(_ phoneNumber: String) -> Bool {
        
        if phoneNumber.count < 10 {
            return false
        } else {
            return true
        }
        
    }
}

extension ProfileVC {
    enum ProfileTypeEnum {
        case createNew
        case edit
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
