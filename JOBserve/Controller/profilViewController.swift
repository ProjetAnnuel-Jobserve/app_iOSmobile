//
//  profilViewController.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 25/05/2022.
//

import UIKit
import Firebase
class profilViewController: UIViewController {

    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var adressUser: UILabel!
    @IBOutlet weak var phoneUser: UILabel!
    @IBOutlet weak var emailUser: UILabel!
    @IBOutlet weak var topicPosted: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var profilView: UIView!
    
    @IBOutlet weak var profilBtn: UIButton!
    @IBOutlet weak var securityBtn: UIButton!
    
    var userID = Auth.auth().currentUser?.uid
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProfil()
    }

    @IBAction func backButtonPressee(_ sender: Any) {
        self.navigationController?.pushViewController(HomeViewController(), animated: true)
    }
    
    func setUpProfil(){
        StyleUtilities.roundView(profilView)
        StyleUtilities.roundButton(topicPosted)
        StyleUtilities.roundButton(logOutBtn)
        StyleUtilities.roundButton(securityBtn)
        StyleUtilities.roundButton(profilBtn)
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        let vc = SignInViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func topicPostedTapped(_ sender: Any) {
        self.navigationController?.pushViewController(topicSendViewController(), animated: false)
    }
    
    @IBAction func securityTapped(_ sender: Any) {
        self.navigationController?.pushViewController(securityViewController(), animated: false)
    }

}
