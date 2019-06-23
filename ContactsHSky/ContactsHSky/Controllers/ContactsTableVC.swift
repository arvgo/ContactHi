//
//  ContactsTableVC.swift
//  ContactsHSky
//
//  Created by RAG on 22/06/2019.
//  Copyright © 2019 RAG. All rights reserved.
//

import UIKit
import Contacts

class ContactsTableVC: UITableViewController {
    
    
    // MARK: - Properties
    // Section Header Index
    private let indexLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    // Contacts
    var contactsOfUser = [CNContact]()
    
    // MARK: - Outlets
    @IBOutlet weak var contactsTableVC: UITableView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        contactsTableVC.backgroundColor = UIColor.white
        
        // MARK: - Set UIBar Button
        let addContactBtnImage = UIImage(named: "createContactBtn")?.withRenderingMode(.alwaysOriginal)
        let addContactBtn = UIBarButtonItem(image: addContactBtnImage, style: .plain, target: self, action: #selector(addContact))
        
        // Set right bar button
        navigationItem.rightBarButtonItem = addContactBtn
        
        // Remove Extra Cells at bottom of TVC
        contactsTableVC.tableFooterView = UIView()
         // MARK: - Set up Contacts
        setUpContacts()
        
    }
    
    // MARK: - TableView
    // Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsOfUser.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectHeader = "PlaceHldr Ind"
        return sectHeader
        
    }
    
    // Rows
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellContact = contactsTableVC.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let contactPerson = contactsOfUser[indexPath.row]
        print(contactPerson)
        
        cellContact.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 0.1485445205)
        cellContact.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cellContact.selectionStyle = .none
        
        // Cell Image
        cellContact.imageView?.image = UIImage(named: "personPlaceholder")
        
        // Add Tab Gesture Recognizer to image
        let imageTap =  MyTapGesture(target: self, action: #selector(self.openCall))
        imageTap.numberOfTapsRequired = 1
        cellContact.imageView?.addGestureRecognizer(imageTap)
        cellContact.imageView?.isUserInteractionEnabled = true
        
        // Contact Name
        cellContact.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        cellContact.textLabel?.text = "\(contactPerson.givenName) \(contactPerson.familyName)"
        
        // Contact Phone number
        cellContact.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        let phone = contactPerson.phoneNumbers.first?.value
        cellContact.detailTextLabel?.text = "\(phone?.stringValue)"
        
        // Send Phone Number on tapping on image
//        imageTap.phoneNumber = "\(phoneNumTs[indexPath.row])"
        
        
        return cellContact
    }
    
    // Swipe action in tableviewcell
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { (action, view, handler) in
            // Call alert message
            self.alertMsg(alertType: "edit", row: indexPath.row)
            print("Edit Action for ", indexPath.row)
        }
        editAction.backgroundColor = .green
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            objects.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
            // Call alert message
            alertMsg(alertType: "delete", row: indexPath.row)
            print("swipe to del ", indexPath.row)
        }
    }
    
    
    // MARK: - Contacts
    fileprivate func setUpContacts() {
        
        let store = CNContactStore()
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        if authorizationStatus == .notDetermined {
            // Ask user for Permission to access user's contacts
            store.requestAccess(for: .contacts) { [weak self] didAuthorize,
                error in
                if didAuthorize {
                    self?.retrieveContacts(from: store)
                }
            }
        } else if authorizationStatus == .authorized {
            retrieveContacts(from: store)
        }
    }
    
    //
    func retrieveContacts(from store: CNContactStore) {
        
        let containerId = store.defaultContainerIdentifier()
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
        // Create a list of Keys
        let keysToFetch = [CNContactGivenNameKey as CNKeyDescriptor,
                           CNContactFamilyNameKey as CNKeyDescriptor,
                           CNContactPhoneNumbersKey as CNKeyDescriptor,
                           CNContactImageDataAvailableKey as
            CNKeyDescriptor,
                           CNContactImageDataKey as CNKeyDescriptor]
        
        do {
            contactsOfUser = try! store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            print("Contacts >> ", contactsOfUser)
        } catch {
            // something went wrong
            print(error)
        }
    }
    
    // MARK: - Phone Number
    @objc func openCall(sender : MyTapGesture) {
        let pNumber = sender.phoneNumber
        print(pNumber)
        callNumber(phoneNumber: pNumber)
    }
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }

    // MARK: - Misc Fncts
    
    @objc func addContact () {
        // Call alert message
        alertMsg(alertType: "add", row: 0)
        print("Add Contact Tapped")
    }
    
    
    func alertMsg(alertType: String, row: Int) {
        
        var titleAlert = ""
        var titleMsg = ""
        
        var contactName = contactsTs[row]
        
        switch alertType {
        case "edit":
            titleAlert = "Editing Contact \(contactName)"
            titleMsg =  "Do you want to edit \(contactName)?"
            print ("edit")
            
        case "delete":
            titleAlert = "Deleting Contact \(contactName)"
            titleMsg = "Do you want to delete \(contactName) from contacts?"
            print ("delete")
            
        case "add":
            titleAlert = "Adding Contact"
            titleMsg = "Do you want to add to contacts?"
            print ("add")
            
        default:
            break
        }
        
        // create the alert
        let alert = UIAlertController(title: titleAlert, message: titleMsg, preferredStyle: .alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch alertType {
            case "edit":
                self.goToProfileVC()
                
            case "delete":
                self.alertAction(actionType: alertType)

            case "add":
                self.goToProfileVC()

            default:
                break
            }
            
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertAction (actionType: String) {
        print("alertACT - ", actionType)
    }
    
    func goToProfileVC () {
        // Go to profile VC
        let storyboard =  UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "profileVC") as! ProfileVC
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
}

extension ContactsTableVC {
    
    struct personContactDetails {
        
        var name: String
        var phoneNumber: Int
        
        init() {
            name = "Test P"
            phoneNumber = 004411323213123
        }
        
    }
    
}

class MyTapGesture: UITapGestureRecognizer {
    var phoneNumber = String()
}
