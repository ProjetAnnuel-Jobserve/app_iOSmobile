//
//  profilViewController.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 25/05/2022.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProfil()
        // Do any additional setup after loading the view.
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
        
       /* nameUser.text = user.firstname+" "+user.lastname
        adressUser.text = user.address+" "+user.zipcode+" "+user.city
        phoneUser.text = user.phoneNumber
        emailUser.text = user.email*/
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        UserDefaults.standard.reset()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
