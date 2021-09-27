//
//  MainTabBar.swift
//  MyLocations
//
//  Created by Elbek Shaykulov on 27/09/21.
//

import UIKit

class MainTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    fileprivate func setupUI(){
        
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        
        viewControllers = [
            makeTabBarController(for: CurrentLocationViewController(), title: "Tag", image: UIImage(named: "Tag")!),
            makeTabBarController(for: CurrentLocationViewController(), title: "Locations", image:UIImage(named:"Locations")!),
            makeTabBarController(for: CurrentLocationViewController(), title: "Map", image: UIImage(named: "Map")!)
        ]
    }
    
    private func makeTabBarController(for rootViewController:UIViewController, title:String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = false
        rootViewController.navigationItem.title = title
        return navController
    }
}
