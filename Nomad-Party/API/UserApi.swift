//
//  UserApi.swift
//  NomadParty 

import Foundation
import FirebaseAuth
import Firebase
import ProgressHUD
import FirebaseStorage
import GoogleSignIn 

class UserApi {
    
    // Use "Api.User" followed by the function to call something in the UserApi class (i.e. Api.User.signIn(), which calls the sign in method) 
    
    var currentUserId: String {
            return Auth.auth().currentUser != nil ? Auth.auth().currentUser!.uid : ""
        }
        
        // Updates user data in Firebase
        func signIn(email: String, password: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
            Auth.auth().signIn(withEmail: email, password: password) { (authData, error) in
                if error != nil {
                    onError(error!.localizedDescription)
                    return
                }
                
                onSuccess()
            }
        }
        
        // Handles user Sign Up
        func signUp (withUsername username: String, email: String, password: String, image: UIImage?, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
            Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    
                    return
                }
                // Dictionary containing user values. Updates user data in Firebase.
                if let authData = authDataResult {
                    let dict: Dictionary<String, Any> =  [
                        UID: authData.user.uid,
                        EMAIL: authData.user.email!,
                        USERNAME: username,
                        PROFILE_IMAGE_URL: "",
                        STATUS: "Status"
                    ]
                    
                    // Profile image upload data for sign up (Currently not in use)
                    guard let imageSelected = image else {
                        ProgressHUD.showError(ERROR_EMPTY_PHOTO)

                        return
                    }
                    
                    guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
                        return
                    }
                    
                    let storageProfile = Ref().storageSpecificProfile(uid: authData.user.uid)
                    
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpg"
                    
                    StorageService.savePhoto(username: username, uid: authData.user.uid, data: imageData, metadata: metadata, storageProfileReference: storageProfile, dict: dict, onSuccess: {
                        onSuccess()
                    }, onError: { (errorMessage) in
                        onError(errorMessage)
                    })
                    
                }
            }
        }
        
        func saveUserProfile(dict: Dictionary<String, Any>,  onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
            Ref().databaseSpecificUser(uid: Api.User.currentUserId).updateChildValues(dict) { (error, dataRef) in
                if error != nil {
                    onError(error!.localizedDescription)
                    return
                }
                onSuccess()
            }
        }
        
        // Sends user a password reset link to their email inbox
        func resetPassword(email: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if error == nil {
                    onSuccess()
                } else {
                    onError(error!.localizedDescription)
                }
            }
        }
        
        // Handle log out
        func logOut() {
            let uid = Api.User.currentUserId
            do {
                Api.User.isOnline(bool: false)
                
                if let providerData = Auth.auth().currentUser?.providerData {
                    let userInfo = providerData[0]
                    
                    switch userInfo.providerID {
                    case "google.com":
                        GIDSignIn.sharedInstance()?.signOut()
                    default:
                        break
                    }
                }
                
                // Records sign out in Firebase
                try Auth.auth().signOut()
                Messaging.messaging().unsubscribe(fromTopic: uid)
            } catch {
                ProgressHUD.showError(error.localizedDescription)
                return
            }
            (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
            
        }
        
//        func observeNewMatch(onSuccess: @escaping(UserCompletion)) {    Ref().databaseRoot.child("newMatch").child(Api.User.currentUserId).observeSingleEvent(of: .value) { (snapshot) in
//                guard let dict = snapshot.value as? [String: Bool] else { return }
//                dict.forEach({ (key, value) in
//                    self.getUserInforSingleEvent(uid: key, onSuccess: { (user) in
//                        onSuccess(user)
//                    })
//                })
//            }
//        }
        
        func observeUsers(onSuccess: @escaping(UserCompletion)) {
            Ref().databaseUsers.observe(.childAdded) { (snapshot) in
                if let dict = snapshot.value as? Dictionary<String, Any> {
                    if let user = User.transformUser(dict: dict) {
                        onSuccess(user)
                    }
                }
            }
        }
        
        func getUserInforSingleEvent(uid: String, onSuccess: @escaping(UserCompletion)) {
            let ref = Ref().databaseSpecificUser(uid: uid)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dict = snapshot.value as? Dictionary<String, Any> {
                    if let user = User.transformUser(dict: dict) {
                        onSuccess(user)
                    }
                }
            }
        }
        
        func getUserInfor(uid: String, onSuccess: @escaping(UserCompletion)) {
            let ref = Ref().databaseSpecificUser(uid: uid)
            ref.observe(.value) { (snapshot) in
                if let dict = snapshot.value as? Dictionary<String, Any> {
                    if let user = User.transformUser(dict: dict) {
                        onSuccess(user)
                    }
                }
            }
        }
        
        func isOnline(bool: Bool) {
            if !Api.User.currentUserId.isEmpty {
                let ref = Ref().databaseIsOnline(uid: Api.User.currentUserId)
                let dict: Dictionary<String, Any> = [
                    "online": bool as Any,
                    "latest": Date().timeIntervalSince1970 as Any
                ]
                ref.updateChildValues(dict)
            }
        }
        
//        func typing(from: String, to: String) {
//            let ref = Ref().databaseIsOnline(uid: from)
//            let dict: Dictionary<String, Any> = [
//                "typing": to
//            ]
//            ref.updateChildValues(dict)
//        } 
    }

    typealias UserCompletion = (User) -> Void

