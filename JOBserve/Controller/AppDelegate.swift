//
//  AppDelegate.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 12/05/2022.
//

import UIKit
import FirebaseCore
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let window = UIWindow(frame: UIScreen.main.bounds)
        let controller = SignInViewController()
        /*
         test
         */
        //let controller = MainTabBarController()
        /*
         */
        window.rootViewController = UINavigationController(rootViewController: controller)
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }

}

