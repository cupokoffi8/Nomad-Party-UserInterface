//
//  SignUpViewController+UI.swift
//  NomadParty 

import UIKit
import ProgressHUD
import CoreLocation
import FirebaseDatabase 

extension SignUpViewController {
    
      // Setup title
      func setupTitleLabel() {
        let title = "Sign Up"
            
            
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Palatino", size: 40)!,
            NSAttributedString.Key.foregroundColor : UIColor.black                                                                       ])
            
        titleTextLabel.attributedText = attributedText
        titleTextLabel.textAlignment = .center 
        }
        
        // Full name field
        func setupFullNameTextField() {
            
            fullnameContainerView.layer.borderWidth = 1
            fullnameContainerView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
            fullnameContainerView.layer.cornerRadius = 3
            fullnameContainerView.clipsToBounds = true
            
            fullnameTextField.borderStyle = .none
            
            let placeholderAttr = NSAttributedString(string: "Full Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
            
            fullnameTextField.attributedPlaceholder = placeholderAttr
            fullnameTextField.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
        }
        
        // Email field
        func setupEmailTextField() {
            emailContainerView.layer.borderWidth = 1
            emailContainerView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
            emailContainerView.layer.cornerRadius = 3
            emailContainerView.clipsToBounds = true
            
            emailTextField.borderStyle = .none
            
            let placeholderAttr = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
            
            emailTextField.attributedPlaceholder = placeholderAttr
            emailTextField.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
        }
        
        // Password field
        func setupPasswordTextField() {
            passwordContainerView.layer.borderWidth = 1
            passwordContainerView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
            passwordContainerView.layer.cornerRadius = 3
            passwordContainerView.clipsToBounds = true
            
            passwordTextField.borderStyle = .none
            
            let placeholderAttr = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
            
            passwordTextField.attributedPlaceholder = placeholderAttr
            passwordTextField.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
            
            
        }
        
        // Sign up button
        func setupSignUpButton() {
            signUpButton.setTitle("Sign Up", for: UIControl.State.normal)
            signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            signUpButton.backgroundColor = UIColor.darkGray 
            signUpButton.layer.cornerRadius = 5
            signUpButton.clipsToBounds = true
            signUpButton.setTitleColor(.white, for: UIControl.State.normal)
        }
        
        // Setup button that takes user to SignInViewController
        func setupSignInButton() {
            
            let attributedText = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)]) 
            let attributedSubText = NSMutableAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.65)])
            attributedText.append(attributedSubText)
            signInButton.setAttributedTitle(attributedText, for: UIControl.State.normal)
            
        }
        
        // On screen keyboard is dismissed by touching another part of the screen.
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
        // Returns an error if fields are empty 
        func validateFields() {
            guard let username = self.fullnameTextField.text, !username.isEmpty else {
                ProgressHUD.showError(ERROR_EMPTY_USERNAME)
                return
            }
            guard let email = self.emailTextField.text, !email.isEmpty else {
                ProgressHUD.showError(ERROR_EMPTY_EMAIL)
                
                return
            }
            guard let password = self.passwordTextField.text, !password.isEmpty else {
                ProgressHUD.showError(ERROR_EMPTY_PASSWORD)
                
                return
            }
            
        }
        
        // Asks user for permission to use their location, and updates their location if validated.
        func configureLocationManager() {
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.distanceFilter = kCLDistanceFilterNone
            manager.pausesLocationUpdatesAutomatically = true
            manager.delegate = self
            manager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                manager.startUpdatingLocation()
            }
        }
        
        // Handles user signing up. UserApi swift file is used to keep track of user data in Firebase.
        func signUp(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
      
            ProgressHUD.show("Loading...")
           
            Api.User.signUp(withUsername: self.fullnameTextField.text!, email: self.emailTextField.text!, password: self.passwordTextField.text!, image: self.image, onSuccess: {
                ProgressHUD.dismiss()
                onSuccess()
            }) { (errorMessage) in
                onError(errorMessage)

            }
           
        }
        
    }

    // Sets up location manager. Implements location manager delegate.
    extension SignUpViewController: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if (status == .authorizedAlways) || (status == .authorizedWhenInUse) {
                manager.startUpdatingLocation()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            ProgressHUD.showError("\(error.localizedDescription)")
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let updatedLocation: CLLocation = locations.first!
            let newCoordinate: CLLocationCoordinate2D = updatedLocation.coordinate
            print(newCoordinate.latitude)
            print(newCoordinate.longitude)
            // update location
            let userDefaults: UserDefaults = UserDefaults.standard
            userDefaults.set("\(newCoordinate.latitude)", forKey: "current_location_latitude")
            userDefaults.set("\(newCoordinate.longitude)", forKey: "current_location_longitude")
            userDefaults.synchronize()

        }
    } 
