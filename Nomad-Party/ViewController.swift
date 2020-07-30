//
//  ViewController.swift
//  Nomad-Party
//
//  Created by Alex Gaskins on 7/27/20.
//  Copyright © 2020 Alex Gaskins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

        @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var signInFacebookButton: UIButton!
        @IBOutlet weak var signInGoogleButton: UIButton!
        @IBOutlet weak var createAccountButton: UIButton!
        @IBOutlet weak var termsOfServiceLabel: UILabel!
        @IBOutlet weak var orLabel: UILabel!
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupUI()
            
        }
    
        func setupUI() {
            
            setupHeaderTitle()
            setupOrLabel()
            setupTermsLabel()
            setupFacebookButton()
            setupGoogleButton()
            setupCreateAccountButton()
            
        }
        
    }

