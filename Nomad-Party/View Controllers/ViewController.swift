//
//  ViewController.swift
//  Nomad-Party

import UIKit
import GoogleSignIn

class ViewController: UIViewController {

    // UI Elements corresponding to ViewController 
        @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var signInFacebookButton: UIButton!
        @IBOutlet weak var signInGoogleButton: UIButton!
        @IBOutlet weak var createAccountButton: UIButton!
        @IBOutlet weak var termsOfServiceLabel: UILabel!
        @IBOutlet weak var orLabel: UILabel!
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupUI()
            
            GIDSignIn.sharedInstance()?.presentingViewController = self 
            
        }
    
        func setupUI() {
            
            setupHeaderTitle()
            setupOrLabel()
            setupTermsLabel() 
            setupGoogleButton()
            setupCreateAccountButton()
            
        }
        
    } 
