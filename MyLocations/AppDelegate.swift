//
//  AppDelegate.swift
//  MyLocations
//
//  Created by Elbek Shaykulov on 27/09/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController =  MainTabBar()
        
        if let tabBarViewConts = tabBarController.viewControllers {
            let navController = tabBarViewConts[0] as? UINavigationController
            let controller = navController?.viewControllers.first as? CurrentLocationViewController
            controller?.managedObjectContext = managedObjectContext
        }
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
            self.saveContext()
    }
    
    //MARK:- COREDATA
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyLocations")
        container.loadPersistentStores {_, error in
            if let error = error {
                fatalError("Could not load data store: \(error)")
            }
        }
        return container
    }()
    
    lazy var managedObjectContext = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}



// /Users/elbekshaykulov/Library/Developer/CoreSimulator/Devices/3F08C8C8-2581-41FA-8BC8-59DAC163965F/data/Containers/Data/Application/17F70097-C25D-4D5F-90D3-F4F78F30E33B/
