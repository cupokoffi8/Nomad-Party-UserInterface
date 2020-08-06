//
//  ViewController+UI.swift
//  NomadParty 

import UIKit
import ProgressHUD
import GoogleSignIn
import Firebase

extension ViewController: GIDSignInDelegate {
    
    // Set up title and subtitle
    func setupHeaderTitle() {
    
    // Uses NSAttributedString to allow for title and subtitle formatting 
    let title = "Create a new account"
    let subTitle = "\nBecome a digital nomad today!"
    
    let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Palatino", size: 28)!, NSAttributedString.Key.foregroundColor : UIColor.black
            ])
        let attributedSubTitle = NSMutableAttributedString(string: subTitle, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.systemGray4
            ])
    attributedText.append(attributedSubTitle)
    
        // Sets title + subtitle as a paragraph that is able to show multiple lines 
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 5
    
    attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
    titleLabel.numberOfLines = 0 
    titleLabel.attributedText = attributedText
    titleLabel.textAlignment = .center 
        
    }
    // Setup the "or" label
    func setupOrLabel() {
        
        orLabel.text = "Or"
        orLabel.font = UIFont.boldSystemFont(ofSize: 16)
        orLabel.textColor = UIColor(white: 0, alpha: 0.65)
        orLabel.textAlignment = .center
        
    }
    // Terms and conditions
    func setupTermsLabel() {
        
        let attributedTermsText = NSMutableAttributedString(string: "By selecting Create Account you agree to our ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)
                ])
        let attributedSubTermsText = NSMutableAttributedString(string: "Terms of Service.", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)
                ])
        attributedTermsText.append(attributedSubTermsText)
        
        termsOfServiceLabel.attributedText = attributedTermsText
        termsOfServiceLabel.numberOfLines = 0
    }
    
    // Google button
    func setupGoogleButton() {
        
        signInGoogleButton.setTitle("Sign in with Google", for: UIControl.State.normal)
        signInGoogleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        signInGoogleButton.backgroundColor = UIColor(red: 223/255, green: 74/255, blue: 50/255, alpha: 1)
        signInGoogleButton.layer.cornerRadius = 5
        signInGoogleButton.clipsToBounds = true
        
        signInGoogleButton.setImage(UIImage(named: "icon-google"), for: UIControl.State.normal)
        signInGoogleButton.imageView?.contentMode = .scaleAspectFit
        signInGoogleButton.tintColor = .white
        signInGoogleButton.imageEdgeInsets = UIEdgeInsets(top: 12, left: -10, bottom: 12, right: 0)
        
        GIDSignIn.sharedInstance()?.delegate = self 
        
        signInGoogleButton.addTarget(self, action: #selector(googleButtonDidTap), for: UIControl.Event.touchUpInside)
        
        
    }
    
    // Google Sign In 
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            return
        }
        guard let authentication = user.authentication else {
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            if let error = error {
                ProgressHUD.showError(error.localizedDescription)
                return
            }
            if let authData = result {
            let dict: Dictionary<String, Any> =  [
                UID: authData.user.uid,
                EMAIL: authData.user.email,
                USERNAME: authData.user.displayName,
                PROFILE_IMAGE_URL: (authData.user.photoURL == nil) ? "" : authData.user.photoURL!.absoluteString,
                STATUS: "Status"
            ]
            Ref().databaseSpecificUser(uid: authData.user.uid).updateChildValues(dict, withCompletionBlock: { (error, ref) in
                if error == nil {
                    Api.User.isOnline(bool: true)
                    (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
                    
                } else {
                    ProgressHUD.showError(error!.localizedDescription)
                }
            })
        }
    }
}
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    }
    
    @objc func googleButtonDidTap() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    // Create account button
    func setupCreateAccountButton() {
        
        createAccountButton.setTitle("Create Account", for: UIControl.State.normal)
        createAccountButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        createAccountButton.backgroundColor = UIColor.darkGray
        createAccountButton.layer.cornerRadius = 5
        createAccountButton.clipsToBounds = true
        
    }
    
}
