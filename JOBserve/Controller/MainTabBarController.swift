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
        
       // self.navigationController?.isNavigationBarHidden = true
        setUpTabBar()

        // Do any additional setup after loading the view.
    }
    func setUpTabBar(){
        let HomeController = UINavigationController(rootViewController: HomeViewController())
        HomeController.tabBarItem.image = UIImage(systemName: "archivebox")
        HomeController.tabBarItem.selectedImage = UIImage(systemName: "archivebox")?.withTintColor(UIColor.red)
        HomeController.tabBarItem.title = "Sujets"
       // HomeController.topi
        
        let vc = HomeViewController.HVCevent()
        let HomeControllerEvent = UINavigationController(rootViewController:vc)
        HomeControllerEvent.tabBarItem.image = UIImage(systemName: "star")
        HomeControllerEvent.tabBarItem.selectedImage = UIImage(systemName: "star")?.withTintColor(UIColor.red)
        HomeControllerEvent.tabBarItem.title = "Evenement"
        
        
        viewControllers = [HomeController,HomeControllerEvent]
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
