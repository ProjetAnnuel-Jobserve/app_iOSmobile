//
//  topicSendViewController.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 25/05/2022.
//

import UIKit
import Firebase

class topicSendViewController: UIViewController {
    
    @IBOutlet weak var topicView: UIView!
    
    
    @IBOutlet weak var profilBtn: UIButton!
    @IBOutlet weak var securityBtn: UIButton!
    @IBOutlet weak var topicBtn: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!
    
    var userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTopic()
    }
    
    func setUpTopic(){
        StyleUtilities.roundView(topicView)
        StyleUtilities.roundButton(topicBtn)
        StyleUtilities.roundButton(logOutBtn)
        StyleUtilities.roundButton(securityBtn)
        StyleUtilities.roundButton(profilBtn)
    }

    @IBAction func profilTapped(_ sender: Any) {
        self.navigationController?.pushViewController(profilViewController(), animated: false)
    }
    @IBAction func securityTapped(_ sender: Any) {
        self.navigationController?.pushViewController(securityViewController(), animated: false)
    }
    @IBAction func logOutTapped(_ sender: Any) {
        let vc = SignInViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.pushViewController(HomeViewController(), animated: true)
    }

}
