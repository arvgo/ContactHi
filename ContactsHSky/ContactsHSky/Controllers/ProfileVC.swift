//
//  ViewController.swift
//  ContactsHSky
//
//  Created by RAG on 22/06/2019.
//  Copyright © 2019 RAG. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    // MARK: - Properties
    
    
    
    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameTxtFld: UITextField!
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
        
        
    }

    // MARK: - IB Actions
    @IBAction func cancelTapped(_ sender: Any) {
        print("cancel Tapped")
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        print("csave Tapped")
    }
    
}

