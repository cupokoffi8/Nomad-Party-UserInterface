//
//  AppDelegate.swift
//  Nomad-Party
//
//  Created by Alex Gaskins on 7/27/20.
//  Copyright © 2020 Alex Gaskins. All rights reserved.
//

import UIKit
import Firebase 

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? 

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = UIColor(red: 93/255, green: 79/255, blue: 141/255, alpha: 1)
        let backImg = UIImage(named: "back")
        UINavigationBar.appearance().backIndicatorImage = backImg
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImg
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: -1000, vertical: 0), for: UIBarMetrics.default) 
        
            FirebaseApp.configure()
            configureInitialViewController()
            
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

}
