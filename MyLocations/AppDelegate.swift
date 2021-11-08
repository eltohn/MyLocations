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
        listenForFatalCoreDataNotifications()
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
    
    
    
    
    //MARK:- NOTIFICATIONs
    
    func listenForFatalCoreDataNotifications() {
        // 1
        NotificationCenter.default.addObserver(
            forName: dataSaveFailedNotification,
            object: nil,
            queue: OperationQueue.main
        ) { _ in
            // 2
            let message = """
          There was a fatal error in the app and it cannot continue.
          Press OK to terminate the app. Sorry for the
          inconvenience.
    """
            // 3
            let alert = UIAlertController(
                title: "Internal Error",
                message: message,
                preferredStyle: .alert)
            // 4
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                let exception = NSException(
                    name: NSExceptionName.internalInconsistencyException,
                    reason: "Fatal Core Data error",
                    userInfo: nil)
                exception.raise()
            }
            alert.addAction(action)
            
            // 5
            let tabController = self.window!.rootViewController!
            tabController.present(
                alert,
                animated: true,
                completion: nil)
        }
    }
}
