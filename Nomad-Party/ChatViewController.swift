//
//  ChatViewController.swift
//  Nomad-Party
//
//  Created by Alex Gaskins on 7/27/20.
//  Copyright © 2020 Alex Gaskins. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

class ChatViewController: UIViewController {

    @IBOutlet weak var mediaButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
   
    var imagePartner: UIImage!
    var avatarImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36)) 
    var topLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    var partnerUsername: String!
    var partnerId: String!
    var placeholderLbl = UILabel()
    var picker = UIImagePickerController()
    var messages = [Message]() 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPicker()
        setupInputContainer()
        setupNavigationBar()
        setupTableView()
        observeMessages()
        // Do any additional setup after loading the view.
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false 
        
    }
    
    @IBAction func sendBtnDidTapped(_ sender: Any) {
        
        if let text = inputTextView.text, text != "" {
            
            inputTextView.text = ""
            self.textViewDidChange(inputTextView) 
            sendToFirebase(dict: ["text": text as Any])
            
        }
        
    }
    
    @IBAction func mediaBtnDidTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "NomadParty", message: "Select source", preferredStyle: UIAlertController.Style.actionSheet)
        let camera = UIAlertAction(title: "Take a picture", style: UIAlertAction.Style.default) { (_) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                
                self.picker.sourceType = .camera
                self.present(self.picker, animated: true, completion: nil)
                
            } else {
                
                print("Unavailable")
                
            }
            
        }
        
        let library = UIAlertAction(title: "Choose an Image or Video", style: UIAlertAction.Style.default) { (_) in
        
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                
                self.picker.sourceType = .photoLibrary
                self.present(self.picker, animated: true, completion: nil)
                
            } else {
                
                print("Unavailable")
                
            }
        }
        
        let videoCamera = UIAlertAction(title: "Take a video", style: UIAlertAction.Style.default) { (_) in
        
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                
                self.picker.sourceType = .camera
                self.picker.mediaTypes = [String(kUTTypeMovie)]
                self.picker.videoExportPreset = AVAssetExportPresetPassthrough
                self.picker.videoMaximumDuration = 30
                self.present(self.picker, animated: true, completion: nil)
                
            } else {
                
                print("Unavailable")
                
            }
        }
    
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        alert.addAction(videoCamera)
        
        present(alert, animated: true, completion: nil)
        
    } 
    
} 
