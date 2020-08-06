//
//  MessageApi.swift
//  Nomad-Party 

import Foundation
import Firebase

class MessageApi {
    
    // Api.Message 
    
    // Group each message with its corresponding user 
    func sendMessage(from: String, to: String, value: Dictionary<String, Any>) {
        
        let ref = Ref().databaseMessageSendTo(from: from, to: to)
        ref.childByAutoId().updateChildValues(value)
        
        var dict = value
        
        if let text = dict["text"] as? String, text.isEmpty {
            dict["imageUrl"] = nil
            dict["height"] = nil
            dict["width"] = nil
            
        }
        // Message from users
        let refFrom = Ref().databaseInboxInfor(from: from, to: to)
        refFrom.updateChildValues(dict)
        // Message to users
        let refTo = Ref().databaseInboxInfor(from: to, to: from)
        refTo.updateChildValues(dict) 
        
    }
    // Updates to show message sent from each end 
    func receiveMessage(from: String, to: String, onSuccess: @escaping(Message) -> Void) {
        
        let ref = Ref().databaseMessageSendTo(from: from, to: to)
        ref.observe(.childAdded) { (snapshot) in
            
            if let dict = snapshot.value as? Dictionary<String, Any> {
                
                if let message = Message.transformMessage(dict: dict, keyId: snapshot.key) {
                onSuccess(message) 
                }
            }
            
        }
        
    }
    
}
