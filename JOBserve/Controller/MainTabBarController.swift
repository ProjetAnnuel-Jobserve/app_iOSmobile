//
//  MainTabBarController.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 22/06/2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        setUpTabBar()
    }
    func setUpTabBar(){
        let HomeController = UINavigationController(rootViewController: HomeViewController())
        HomeController.tabBarItem.image = UIImage(systemName: "archivebox")
        HomeController.tabBarItem.selectedImage = UIImage(systemName: "archivebox")?.withTintColor(UIColor.red)
        HomeController.tabBarItem.title = "Sujets"
        
        let vc = HomeViewController.HVCevent()
        let HomeControllerEvent = UINavigationController(rootViewController:vc)
        HomeControllerEvent.tabBarItem.image = UIImage(systemName: "star")
        HomeControllerEvent.tabBarItem.selectedImage = UIImage(systemName: "star")?.withTintColor(UIColor.red)
        HomeControllerEvent.tabBarItem.title = "Evenement"
        
        
        viewControllers = [HomeController,HomeControllerEvent]
    }
}
