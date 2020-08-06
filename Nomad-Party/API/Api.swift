//
//  Api.swift
//  NomadParty 

import Foundation
struct Api {
    // Instances of methods used for user services
    
    static var User = UserApi() // Authentication services
    
    static var Message = MessageApi() // Message services
    
    static var Inbox = InboxApi() // Inbox services
    
}
