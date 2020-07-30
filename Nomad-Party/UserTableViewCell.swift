//
//  UserTableViewCell.swift
//  Nomad-Party
//
//  Created by Alex Gaskins on 7/27/20.
//  Copyright © 2020 Alex Gaskins. All rights reserved.
//

import UIKit


class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    var user: User!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = 30
        avatar.clipsToBounds = true
        // Initialization code
    }

    func loadData(_ user: User) {
        
        self.user = user 
        self.usernameLbl.text = user.username
        self.statusLbl.text = user.status
        self.avatar.loadImage(user.profileImageUrl)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
