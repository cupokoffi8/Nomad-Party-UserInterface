//
//  InboxTableViewCell.swift
//  Nomad-Party 

import UIKit
import Firebase

class InboxTableViewCell: UITableViewCell {
    
    // UI Elements corresponding to InboxTableViewCell 
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var onlineView: UIView!
    
        var user: User!
        var inboxChangedOnlineHandle: DatabaseHandle!
        var inboxChangedProfileHandle: DatabaseHandle!
        var inboxChangedMessageHandle: DatabaseHandle!

        var inbox: Inbox!
        var controller: MessagesTableViewController!
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
            avatar.layer.cornerRadius = 30
            avatar.clipsToBounds = true
            onlineView.isHidden = true 
            
        }
        
        // Sets properties based off of user data in Firebase 
        func configureCell(uid: String, inbox: Inbox) {
            self.user = inbox.user
            self.inbox = inbox
            avatar.loadImage(inbox.user.profileImageUrl)
            usernameLbl.text = inbox.user.username
            let date = Date(timeIntervalSince1970: inbox.date)
            let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
            dateLbl.text = dateString
            
            if !inbox.text.isEmpty {
                messageLbl.text = inbox.text
            } else {
                messageLbl.text = "[MEDIA]"
            }
            
            let refInbox = Ref().databaseInboxInfor(from: Api.User.currentUserId, to: inbox.user.uid)
           
            if inboxChangedMessageHandle != nil {
                refInbox.removeObserver(withHandle: inboxChangedMessageHandle)
            }
            // This is supposed to handle message updates in the inbox, but it is being buggy... 
            
//            inboxChangedMessageHandle = refInbox.observe(.childChanged, with: { (snapshot) in
//                if let snap = snapshot.value {
//                    self.inbox.updateData(key: snapshot.key, value: snap)
//                    self.controller.sortedInbox()
//                }
//            })
            
            let refOnline = Ref().databaseIsOnline(uid: inbox.user.uid)
            refOnline.observeSingleEvent(of: .value) { (snapshot) in
                if let snap = snapshot.value as? Dictionary<String, Any> {
                    if let active = snap["online"] as? Bool {
                        self.onlineView.backgroundColor = active == true ? .green : .red
                    }
                }
            }
            if inboxChangedOnlineHandle != nil {
                refOnline.removeObserver(withHandle: inboxChangedOnlineHandle)
            }
            
//            inboxChangedOnlineHandle = refOnline.observe(.childChanged) { (snapshot) in
//                if let snap = snapshot.value {
//                    if snapshot.key == "online" {
//                        self.onlineView.backgroundColor = (snap as! Bool) == true ? .green : .red
//                    }
//                }
//            } 
            
            let refUser = Ref().databaseSpecificUser(uid: inbox.user.uid)
            if inboxChangedProfileHandle != nil {
                refUser.removeObserver(withHandle: inboxChangedProfileHandle)
            }
            
            // Profile Changes in inbox: (It was being buggy)
            
//            inboxChangedProfileHandle = refUser.observe(.childChanged, with: { (snapshot)               in
//                if let snap = snapshot.value as? String {
//                    self.user.updateData(key: snapshot.key, value: snap)
//                    self.controller.sortedInbox()
//                }
//            })
            
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            let refOnline = Ref().databaseIsOnline(uid: self.inbox.user.uid)
            if inboxChangedOnlineHandle != nil {
                refOnline.removeObserver(withHandle: inboxChangedOnlineHandle)
            }
            
            let refUser = Ref().databaseSpecificUser(uid: inbox.user.uid)
            if inboxChangedProfileHandle != nil {
                refUser.removeObserver(withHandle: inboxChangedProfileHandle)
            }
            let refInbox = Ref().databaseInboxInfor(from: Api.User.currentUserId, to: inbox.user.uid)
            
             if inboxChangedMessageHandle != nil {
                 refInbox.removeObserver(withHandle: inboxChangedMessageHandle)
             }
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }

    }
