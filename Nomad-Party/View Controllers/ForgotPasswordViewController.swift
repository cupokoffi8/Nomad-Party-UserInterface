//
//  ForgotPasswordViewController.swift
//  NomadParty 

import UIKit
import ProgressHUD

class ForgotPasswordViewController: UIViewController {

    // UI Elements corresponding to ForgotPasswordViewController 
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      setupUI()
        
          }
          
          func setupUI() {
              
              // Functions for customizing UI properties 
              setupEmailTextField()
              setupResetButton()
              
          }
    
    @IBAction func dismissAction(_ sender: Any) {
        // Returns to previous screen
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func resetPasswordDidTapped(_ sender: Any) {
        
        guard let email = emailTextField.text, email != "" else {
            // Error message is shown if no email is enter
            ProgressHUD.showError(ERROR_EMPTY_EMAIL_RESET)
            return 
        }
        
        Api.User.resetPassword(email: email, onSuccess: {
            self.view.endEditing(true)
            // Show success
            ProgressHUD.showSuccess(SUCCESS_EMAIL_RESET)
            self.navigationController?.popViewController(animated: true)
        }) { (errorMessage) in
            // Error message is shown if email doesn't work
            ProgressHUD.showError(errorMessage)
        }
        
    }
    
}
