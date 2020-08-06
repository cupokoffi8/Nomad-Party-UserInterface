//
//  ProfileTableViewController.swift
//  Nomad-Party 

import UIKit
import ProgressHUD 

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameLbl: UITextField!
    @IBOutlet weak var emailLbl: UITextField!
    @IBOutlet weak var statusLbl: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        observeData()
        
    }
    
    func setupView() {
        setupAvatar()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupAvatar() {
        avatar.layer.cornerRadius = 40
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action:
            #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
    }
    
    @objc func presentPicker() {
        
        view.endEditing(true)
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    } 
    
    func observeData() {
        
        Api.User.getUserInforSingleEvent(uid: Api.User.currentUserId) { (user) in 
            self.usernameLbl.text = user.username
            self.emailLbl.text = user.email
            self.statusLbl.text = user.status
            self.avatar.loadImage(user.profileImageUrl)
            
            if let age = user.age {
                self.ageTextField.text = "\(age)"
            } else {
                self.ageTextField.placeholder = "Optional"
            }
            
        }
        
    }
    
    
    @IBAction func logoutBtnDidTapped(_ sender: Any) {

                Api.User.logOut()
        
    }
    
    
    @IBAction func saveBtnDidTapped(_ sender: Any) {
            ProgressHUD.show("Loading")
            
            var dict = Dictionary<String, Any>()
            if let username = usernameLbl.text, !username.isEmpty {
                dict["username"] = username
            }
            if let email = emailLbl.text, !email.isEmpty {
                dict["email"] = email
            }
            if let status = statusLbl.text, !status.isEmpty {
                dict["status"] = status
            }
        if let age = ageTextField.text, !age.isEmpty { 
            dict["age"] = Int(age)
        }
        
        Api.User.saveUserProfile(dict: dict, onSuccess: {
                   if let img = self.image {
                       StorageService.savePhotoProfile(image: img, uid: Api.User.currentUserId,
                           onSuccess: {
                               ProgressHUD.showSuccess()
                       }) { (errorMessage) in
                           ProgressHUD.showError(errorMessage)
                       }
                   } else {
                    ProgressHUD.showSuccess() 
            }
            
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
            }
        }
    }

extension ProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as?
            UIImage {
            image = imageSelected
            avatar.image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.editedImage] as?
            UIImage {
            image = imageOriginal
            avatar.image = imageOriginal
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}
