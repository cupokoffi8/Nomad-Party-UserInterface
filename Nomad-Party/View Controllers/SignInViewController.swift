//
//  SignInViewController.swift
//  NomadParty 

import UIKit
import ProgressHUD

class SignInViewController: UIViewController {

    // UI Elements corresponding to SignInViewController
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    setupUI()
        
           }
           
           func setupUI() {
               
               // Functions for customizing UI properties
               setupTitleTextLabel()
               setupEmailTextField()
               setupPasswordTextField()
               setupSignInButton()
               setupSignUpButton()
            
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        
        // Takes user to previous screen 
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func signInButtonDidTapped(_ sender: Any) {
        // If successful, the user is logged in and remains logged in until they decide to log out
        self.view.endEditing(true)
        self.validateFields()
        self.signIn(onSuccess: {
            // User status is set to online after sign in button is tapped and user successfully logged in
            Api.User.isOnline(bool: true) 
            (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController() 
        }) { (errorMessage) in
            // If sign in is unsuccessful an error message is shown 
            ProgressHUD.showError(errorMessage)
        }
        
    }
    
    
}
