//
//  ContactsTableVC.swift
//  ContactsHSky
//
//  Created by RAG on 22/06/2019.
//  Copyright © 2019 RAG. All rights reserved.
//

import UIKit

class ContactsTableVC: UITableViewController {
    
    
    // MARK: - Properties
    // Section Header Index
    private let indexLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

    var contactsTs = ["Ar", "Ab", "Baa", "Effe"]
    var phoneNumTs = ["0123", "0221", "00222", "022343"]
    
    
    // MARK: - Outlets
    @IBOutlet weak var contactsTableVC: UITableView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        contactsTableVC.backgroundColor = UIColor.white
        
        // MARK: - Set UIBar Button
        let addContactBtnImage = UIImage(named: "createContactBtn")?.withRenderingMode(.alwaysOriginal)
        let addContactBtn = UIBarButtonItem(image: addContactBtnImage, style: .plain, target: self, action: #selector(addContact))
        addContactBtn.tintColor = UIColor.black
        
        // Set right bar button
        navigationItem.rightBarButtonItem = addContactBtn
        
        // Remove Extra Cells at bottom of TVC
        contactsTableVC.tableFooterView = UIView()
    }
    
    // MARK: - TableView
    // Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsTs.count
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
        
        cellContact.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 0.1485445205)
        cellContact.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cellContact.selectionStyle = .none
        
        cellContact.imageView?.image = UIImage(named: "personPlaceholder")
        
        cellContact.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        cellContact.textLabel?.text = contactsTs[indexPath.row]
        
        cellContact.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        cellContact.detailTextLabel?.text = phoneNumTs[indexPath.row]
        
        
        return cellContact
    }
    
    // Swipe action
    
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
    
    
    // MARK: - Phone Number

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
