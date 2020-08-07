//
//  ViewController+UI.swift
//  NomadParty
//
//  Created by Alex Gaskins on 7/26/20.
//  Copyright © 2020 Alex Gaskins. All rights reserved.
//

import UIKit
import FBSDKLoginKit

extension ViewController {
    
    func setupHeaderTitle() {
    
    let title = "Create a new account"
    let subTitle = "\nBecome a digital nomad today!"
    
    let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Didot", size: 28)!, NSAttributedString.Key.foregroundColor : UIColor.black
            ])
    let attributedSubTitle = NSMutableAttributedString(string: subTitle, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.45)
            ])
    attributedText.append(attributedSubTitle)
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 5
    
    attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
    titleLabel.numberOfLines = 0
    
    titleLabel.attributedText = attributedText
        
    }
    
    func setupOrLabel() {
        
        orLabel.text = "Or"
        orLabel.font = UIFont.boldSystemFont(ofSize: 16)
        orLabel.textColor = UIColor(white: 0, alpha: 0.45)
        orLabel.textAlignment = .center
        
    }
    
    func setupTermsLabel() {
        
        let attributedTermsText = NSMutableAttributedString(string: "By selecting Create Account you agree to our ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)
                ])
        let attributedSubTermsText = NSMutableAttributedString(string: "Terms of Service.", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)
                ])
        attributedTermsText.append(attributedSubTermsText)
        
        termsOfServiceLabel.attributedText = attributedTermsText
        termsOfServiceLabel.numberOfLines = 0
    }
    
    func setupFacebookButton() {
        
        signInFacebookButton.setTitle("Sign in with Facebook", for: UIControl.State.normal)
        signInFacebookButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        signInFacebookButton.backgroundColor = UIColor(red: 58/255, green: 85/255, blue: 159/255, alpha: 1)
        signInFacebookButton.layer.cornerRadius = 5
        signInFacebookButton.clipsToBounds = true
        
        signInFacebookButton.setImage(UIImage(named: "icon-facebook"), for: UIControl.State.normal)
        signInFacebookButton.imageView?.contentMode = .scaleAspectFit
        signInFacebookButton.tintColor = .white
        signInFacebookButton.imageEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
    }
    
    //Facebook Login
    func signinFacebookBUtton(){
        let loginButton = FBLoginButton()
        loginButton.permissions = ["public_profile", "email"]
    }
    
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
        
    }
    
    func setupCreateAccountButton() {
        
        createAccountButton.setTitle("Create Account", for: UIControl.State.normal)
        createAccountButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        createAccountButton.backgroundColor = UIColor.darkGray
        createAccountButton.layer.cornerRadius = 5
        createAccountButton.clipsToBounds = true
        
    }
    
}
