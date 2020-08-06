//
//  MessagesTableViewController.swift
//  NomadParty

import UIKit
import FirebaseAuth

class MessagesTableViewController: UITableViewController {

    var inboxArray = [Inbox]()
    var avatarImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36)) 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar() 
        setupTableView()
        observeInbox()
        
    }
    
    // Setup navigation bar UI 
    func setupNavigationBar() {
        
        navigationItem.title = "Messages"
        navigationController?.navigationBar.prefersLargeTitles = true
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 18
        avatarImageView.clipsToBounds = true
        containView.addSubview(avatarImageView)
        
        let leftBarButton = UIBarButtonItem(customView: containView)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        if let currentUser = Auth.auth().currentUser, let photoUrl = currentUser.photoURL {
            avatarImageView.loadImage(photoUrl.absoluteString)
        }
        
//        Updates profile image after being changed in Settings 
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfile), name: NSNotification.Name("updateProfileImage"), object: nil)
        
    }
    
    @objc func updateProfile() {
        if let currentUser = Auth.auth().currentUser, let photoUrl = currentUser.photoURL {
            avatarImageView.loadImage(photoUrl.absoluteString)
        }
    }
    
    // Sorts messages in inbox array chronologically
    func observeInbox() {
        Api.Inbox.lastMessages(uid: Api.User.currentUserId) { (inbox) in
            if !self.inboxArray.contains(where: { $0.user.uid == inbox.user.uid }) {
                self.inboxArray.append(inbox)
                self.sortedInbox()
            }
        }
    }
    
    // Updates inbox when changes are made.
    func sortedInbox() {
        
        inboxArray = inboxArray.sorted(by: { $0.date > $1.date })
        DispatchQueue.main.async {
            self.tableView.reloadData()
                   
        }
    }
    
    func setupTableView() {
        
        tableView.tableFooterView = UIView()
        
    } 
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return inboxArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxTableViewCell", for: indexPath) as! InboxTableViewCell

        let inbox = self.inboxArray[indexPath.row]
        cell.configureCell(uid: Api.User.currentUserId, inbox: inbox) 

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94 
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if let cell = tableView.cellForRow(at: indexPath) as? InboxTableViewCell { 
            let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
            let chatVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_CHAT) as! ChatViewController
            chatVC.imagePartner = cell.avatar.image
            chatVC.partnerUsername = cell.usernameLbl.text
            chatVC.partnerId = cell.user.uid
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
}
