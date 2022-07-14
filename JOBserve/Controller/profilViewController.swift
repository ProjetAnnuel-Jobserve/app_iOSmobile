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
    @IBOutlet weak var permissionUser: UILabel!
    @IBOutlet weak var topicPosted: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var profilView: UIView!
    
    @IBOutlet weak var profilBtn: UIButton!
    @IBOutlet weak var securityBtn: UIButton!
    
    var userID = Auth.auth().currentUser?.uid
    var currentUser : User?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
        setUpProfil()
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonUser = try? decoder.decode(User.self, from: json){
            self.currentUser = jsonUser
        }
        else{
            print("Error PArse")
        }
        
    }
    func loadUser(){
        // A modifier
        let urlApi = "https://jobserve-moc.herokuapp.com/users-firebase/\(self.userID!)"
        if let url = URL(string: urlApi ){
        if let data = try? Data(contentsOf: url){
            parse(json: data)
        }
        }
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
        if let currentUser = currentUser {
            self.nameUser.text = currentUser.firstname+" "+currentUser.lastname
            self.emailUser.text = currentUser.email
            self.adressUser.text = currentUser.location
            self.phoneUser.text = currentUser.phoneNumber
            self.permissionUser.text = currentUser.permission
            
        }
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
