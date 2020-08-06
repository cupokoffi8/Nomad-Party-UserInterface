//
//  SignInViewController+UI.swift
//  NomadParty 

import UIKit
import FirebaseAuth
import Firebase
import FirebaseCore
import ProgressHUD
import FirebaseDatabase 

extension SignInViewController {
    
    // Setup title
    func setupTitleTextLabel() {
        
        let title = "Sign In"
        
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Palatino", size: 40)!, NSAttributedString.Key.foregroundColor : UIColor.black
                ])
        
        titleTextLabel.attributedText = attributedText
        titleTextLabel.textAlignment = .center 
    }
    
    // Setup email field
    func setupEmailTextField() {
        
        emailContainerView.layer.borderWidth = 1
        emailContainerView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        emailContainerView.layer.cornerRadius = 3
        emailContainerView.clipsToBounds = true
        
        emailTextField.borderStyle = .none
        
        let placeholderAttr = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        
        emailTextField.attributedPlaceholder = placeholderAttr
        emailTextField.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
        
    }
    
    // Setup password field
    func setupPasswordTextField() {
        
        passwordContainerView.layer.borderWidth = 1
        passwordContainerView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        passwordContainerView.layer.cornerRadius = 3
        passwordContainerView.clipsToBounds = true
        
        passwordTextField.borderStyle = .none
        
        let placeholderAttr = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        
        passwordTextField.attributedPlaceholder = placeholderAttr
        passwordTextField.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
        
    }
    
    // Setup sign in button
    func setupSignInButton() {
        
        signInButton.setTitle("Sign In", for: UIControl.State.normal)
        signInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signInButton.backgroundColor = UIColor.darkGray
        signInButton.layer.cornerRadius = 5
        signInButton.clipsToBounds = true
        signInButton.setTitleColor(.white, for: UIControl.State.normal)
        
    }
    
    // Setup button that takes user to sign up screen
    func setupSignUpButton() {
        
        let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)
                ])
        let attributedSubText = NSMutableAttributedString(string: "Sign Up!", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65) 
                ])
        attributedText.append(attributedSubText)
        signUpButton.setAttributedTitle(attributedText, for: UIControl.State.normal)
        
    }
    
    // Uses ProgressHUD to notify user if email or password doesn't work. Otherwise, the email and password are validated.
    func validateFields() {
        
        guard let email = self.emailTextField.text, !email.isEmpty else {
            ProgressHUD.showError(ERROR_EMPTY_EMAIL)
            return
        }
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            ProgressHUD.showError(ERROR_EMPTY_PASSWORD)
            return
        }
    }
    
    // Signs user in if email and password are correct. 
    func signIn(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        ProgressHUD.show("Loading...") 
        Api.User.signIn(email: self.emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            ProgressHUD.dismiss() 
            onSuccess()
        }) { (errorMessage) in
            onError(errorMessage)
        }
        
    }
    
}
