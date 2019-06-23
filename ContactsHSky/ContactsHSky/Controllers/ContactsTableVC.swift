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
    
    
    
    // MARK: - Phone Number

    // MARK: - Misc Fncts
    
    @objc func addContact () {
        print("Add Contact Tapped")
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
