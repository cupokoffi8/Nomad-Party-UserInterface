//
//  Ref.swift
//  NomadParty
//
//  Created by Alex Gaskins on 7/27/20.
//  Copyright © 2020 Alex Gaskins. All rights reserved.
//

import Foundation
import Firebase

let REF_USER = "users"
let REF_MESSAGE = "messages"
let REF_INBOX = "inbox"
let URL_STORAGE_ROOT = "gs://nomad-party.appspot.com"
let STORAGE_PROFILE = "profile"
let PROFILE_IMAGE_URL = "profileImageUrl"
let UID = "uid"
let EMAIL = "email"
let USERNAME = "username"
let STATUS = "status"
let ERROR_EMPTY_PHOTO = "Please choose your profile image"
let ERROR_EMPTY_EMAIL = "Please enter an email address"
let ERROR_EMPTY_USERNAME = "Please enter a username"
let ERROR_EMPTY_PASSWORD = "Please enter a password"
let ERROR_EMPTY_EMAIL_RESET = "Please enter an email address for password reset"
let SUCCESS_EMAIL_RESET = "A password reset email has been sent"
let IDENTIFIER_TABBAR = "TabBarVC"
let IDENTIFIER_WELCOME = "WelcomeVC"
let IDENTIFIER_CHAT = "ChatVC" 
let IDENTIFIER_CELL_USERS = "UserTableViewCell" 

class Ref {
    let databaseRoot: DatabaseReference = Database.database().reference()
    
    var databaseUser: DatabaseReference {
        return databaseRoot.child(REF_USER)
    }
    
    func databaseSpecificUser(uid: String) -> DatabaseReference {
        return databaseUser.child(uid)
    }
    
    var databaseMessage: DatabaseReference {
        
        return databaseRoot.child(REF_MESSAGE)
        
    }
    
    func databaseMessageSendTo(from: String, to: String) -> DatabaseReference {
        
        return databaseMessage.child(from).child(to) 
        
    }
    
    var databaseInbox: DatabaseReference {
        
        return databaseRoot.child(REF_INBOX)
        
    }
    
    func databaseInboxInfor(from: String, to: String) -> DatabaseReference {
    
    return databaseInbox.child(from).child(to)
        
    }
    
    func databaseInboxForUser(uid: String) -> DatabaseReference {
        
        return databaseInbox.child(uid) 
        
    }
    
    // Storage Ref
    
    let storageRoot = Storage.storage().reference(forURL: URL_STORAGE_ROOT)
    
    var storageProfile: StorageReference {
        return storageRoot.child(STORAGE_PROFILE)
    }
    
    var storageMessage: StorageReference {
        return storageRoot.child(REF_MESSAGE)
    }
    
    func storageSpecificProfile(uid: String) -> StorageReference {
        return storageProfile.child(uid) 
    }
    
    func storageSpecificImageMessage(id: String) -> StorageReference {
        
        return storageMessage.child("photo").child(id) 
        
    }
    
    func storageSpecificVideoMessage(id: String) -> StorageReference {
        
        return storageMessage.child("video").child(id)
        
        }
    
    }
