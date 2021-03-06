//
//  ChatViewController.swift
//  Nomad-Party 

import UIKit
import MobileCoreServices
import AVFoundation
import LBTATools
import ProgressHUD

class ChatViewController: UIViewController {

    @IBOutlet weak var mediaButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var imagePartner: UIImage!
    var avatarImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36)) 
    var topLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    var partnerUsername: String!
    var partnerId: String!
    var partnerUser: User!
    var placeholderLbl = UILabel()
    var picker = UIImagePickerController()
    var messages = [Message]()
    var isActive = false
    var lastTimeOnline = ""
    var isTyping = false
    var timer = Timer()
    var refreshControl = UIRefreshControl()
    var lastMessageKey: String? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPicker()
        setupInputContainer()
        setupNavigationBar()
        setupTableView() 
        // Do any additional setup after loading the view.
        let scrollView = self.tableView!
        scrollView.keyboardDismissMode = .interactive
    }
    
    func handleKeyboardNotification() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
       // Controls tab bar when sending a message to someone
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false 
        // Hides tab bar when in chat view
    }
    
    @IBAction func sendBtnDidTapped(_ sender: Any) {
        // Sets the value in the input text field as the message being sent
        // Stores the value to Firebase
        if let text = inputTextView.text, text != "" {
            
            inputTextView.text = ""
            self.textViewDidChange(inputTextView)
            sendToFirebase(dict: ["text": text as Any])
            
        }
        
    }
    
    @IBAction func mediaBtnDidTapped(_ sender: Any) {
        // Allows pictures and videos to be sent. It is buggy in the simulator.
        let alert = UIAlertController(title: "NomadParty", message: "Select source", preferredStyle: UIAlertController.Style.actionSheet)
        let camera = UIAlertAction(title: "Take a picture", style: UIAlertAction.Style.default) { (_) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                
                self.picker.sourceType = .camera
                self.present(self.picker, animated: true, completion: nil)
                
            } else {
                
                print("Unavailable")
                
            }
            
        }
        // Photo library
        let library = UIAlertAction(title: "Choose an Image or Video", style: UIAlertAction.Style.default) { (_) in
        
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                
                self.picker.sourceType = .photoLibrary
                self.present(self.picker, animated: true, completion: nil)
                
            } else {
                
                print("Unavailable")
                
            }
        }
        // User can take up to 30 seconds of video to send 
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
