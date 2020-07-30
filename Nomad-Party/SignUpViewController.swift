//
//  SignUpViewController.swift
//  NomadParty
//
//  Created by Alex Gaskins on 7/26/20.
//  Copyright © 2020 Alex Gaskins. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var fullnameContainerView: UIView!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    var image: UIImage? = nil 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        
        setupTitleLabel()
        setupAvatar()
        setupFullNameTextField()
        setupEmailTextField()
        setupPasswordTextField()
        setupSignUpButton()
        setupSignInButton() 
        
    }

    @IBAction func dismissAction(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    
    @IBAction func signUpButtonDidTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        self.validateFields()
        self.signUp(onSuccess: {
            (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController() 
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
        
    }
    
}
