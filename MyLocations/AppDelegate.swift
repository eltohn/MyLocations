//
//  AppDelegate.swift
//  MyLocations
//
//  Created by Elbek Shaykulov on 27/09/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController =  MainTabBar()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
}

