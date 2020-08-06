//
//  MessageTableViewCell.swift
//  Nomad-Party 

import UIKit
import AVFoundation

class MessageTableViewCell: UITableViewCell {

    // UI Elements corresponding to MessageTableViewCell
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var photoMessage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var textMessageLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var message: Message! 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup UI appearance 
        bubbleView.layer.cornerRadius = 15
        bubbleView.clipsToBounds = true
        bubbleView.layer.borderWidth = 0.4
        textMessageLabel.numberOfLines = 0
        photoMessage.layer.cornerRadius = 15
        photoMessage.clipsToBounds = true
        profileImage.layer.cornerRadius = 16
        profileImage.clipsToBounds = true
        
        photoMessage.isHidden = true
        profileImage.isHidden = true
        textMessageLabel.isHidden = true
        
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating() 
        
    }
    
    // Play button for video messages 
    @IBAction func playButtonDidTapped(_ sender: Any) {
        
        handlePlay()
        
    }
    
    var observation: Any? = nil
    
    // Play video messages
    func handlePlay() {
        
        let videoUrl = message.videoUrl
        if videoUrl.isEmpty {
            return
        }
        if let url = URL(string: videoUrl) {
            
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            playerLayer?.frame = photoMessage.frame
            observation = player?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
            bubbleView.layer.addSublayer(playerLayer!)
            player?.play()
            playButton.isHidden = true
            
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "status" {
            
            let status: AVPlayer.Status = player!.status
            switch (status) {
                
            case AVPlayer.Status.readyToPlay:
                
                activityIndicatorView.isHidden = true
                activityIndicatorView.stopAnimating()
                break
                
            case AVPlayer.Status.unknown, AVPlayer.Status.failed:
                break
                
            @unknown default:
                break
                
            }
            
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoMessage.isHidden = true
        profileImage.isHidden = true
        textMessageLabel.isHidden = true
        
        if observation != nil {
            
            stopObservers()
            
        }
        
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        playButton.isHidden = false
        
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
        
    }
    
    func stopObservers() {
        
        player?.removeObserver(self, forKeyPath: "status")
        observation = nil
        
    }
    
    // Configure what information is displayed in the message. Each text message is setup in a bubble view, and a view cell with the message data is added to the table view in a green bubble view for the user, and a gray bubble view for the person they are messaging.
    func configureCell(uid: String, message: Message, image: UIImage) {
        
        self.message = message
        let text = message.text
        if !text.isEmpty {
            textMessageLabel.isHidden = false
            textMessageLabel.text = message.text
            
            let widthValue = text.estimateFrameForText(text).width + 40 
            
            // Width of bubble view does not go below 75
            if widthValue < 75 {
                widthConstraint.constant = 75
            } else {
                widthConstraint.constant = widthValue
            }
        } else {
            photoMessage.isHidden = false
            photoMessage.loadImage(message.imageUrl)
            bubbleView.layer.borderColor = UIColor.clear.cgColor
            widthConstraint.constant = 250
            dateLabel.textColor = .darkGray
        }
        
        // Setup appearance of user messages
        if uid == message.from {
            bubbleView.backgroundColor = UIColor.systemGreen
            bubbleView.layer.borderColor = UIColor.clear.cgColor
            textMessageLabel.textColor = .white
            bubbleRightConstraint.constant = 8
            bubbleLeftConstraint.constant = UIScreen.main.bounds.width - widthConstraint.constant - bubbleRightConstraint.constant
        } else {
            // Setup appearance of messages from other users
            profileImage.isHidden = false
            bubbleView.backgroundColor = UIColor.gray
            textMessageLabel.textColor = .white
            profileImage.image = image
            bubbleView.layer.borderColor = UIColor.lightGray.cgColor
            bubbleLeftConstraint.constant = 55
            bubbleRightConstraint.constant = UIScreen.main.bounds.width - widthConstraint.constant - bubbleLeftConstraint.constant 
        }
        // Shows when messages was sent
        let date = Date(timeIntervalSince1970: message.date)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        dateLabel.text = dateString 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
