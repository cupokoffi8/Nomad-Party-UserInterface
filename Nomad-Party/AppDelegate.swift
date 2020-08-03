//
//  AppDelegate.swift
//  Nomad-Party
//
//  Created by Alex Gaskins on 7/27/20.
//  Copyright © 2020 Alex Gaskins. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseAuth 

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let gcmMessageIDKey = "gcm.message_id"
    
    static var isToken: String? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        InstanceID.instanceID().instanceID { (result, error) in
            
            if let error = error {
                
                print("Error fetching remote instange ID: (\(error)")
                
            } else if let result = result {
                
                print("Remote instance ID token: \(result.token)")
                
                AppDelegate.isToken = result.token
                
            }
            
        }
        
        UINavigationBar.appearance().tintColor = UIColor(red: 93/255, green: 79/255, blue: 141/255, alpha: 1)
        let backImg = UIImage(named: "back")
        UINavigationBar.appearance().backIndicatorImage = backImg
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImg
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: -1000, vertical: 0), for: UIBarMetrics.default) 
        
            FirebaseApp.configure()
            configureInitialViewController()
        
        if #available(iOS 10.0, *) {
            let current = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.sound, .badge, .alert]
            
            current.requestAuthorization(options: options) { (granted, error) in
                if error != nil {
                    
                } else {
                    Messaging.messaging().delegate = self
                    current.delegate = self
                    
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            let types: UIUserNotificationType = [.sound, .badge, .alert]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
            
            return true
        }
        
        func configureInitialViewController() {
            var initialVC: UIViewController
            let storyboard = UIStoryboard(name: "Welcome", bundle: nil)

            if Auth.auth().currentUser != nil {
                initialVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_TABBAR)
            } else {
                initialVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_WELCOME)
            }

            window?.rootViewController = initialVC
            window?.makeKeyAndVisible()
        }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo:
        [AnyHashable : Any]) {
        if let messageId = userInfo[gcmMessageIDKey] {
            print("messageId: \(messageId)")
        }
        
        print(userInfo)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo:  [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageId = userInfo[gcmMessageIDKey] {
            print("messageId: \(messageId)")
        }
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard let token = AppDelegate.isToken else {
            return
        }
        print("token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription) 
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping
        (UNNotificationPresentationOptions) -> Void) {
    
        let userInfo = notification.request.content.userInfo
        
        if let message = userInfo[gcmMessageIDKey] {
            print("Message: \(message)")
        }
        
        print(userInfo)
        
        completionHandler([.sound, .badge, .alert])
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        guard let token = AppDelegate.isToken else {
            return
        }
        print("Token: \(token)")
    }
    
}
