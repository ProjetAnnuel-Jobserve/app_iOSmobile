//
//  securityViewController.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 25/05/2022.
//

import UIKit
import Firebase

class securityViewController: UIViewController {

    @IBOutlet weak var profilBtn: UIButton!
    @IBOutlet weak var securityBtn: UIButton!
    @IBOutlet weak var newPwdTF: UITextField!
    @IBOutlet weak var confirmPwdTF: UITextField!
    @IBOutlet weak var topicPosted: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var changePwdBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSecurity()

        // Do any additional setup after loading the view.
    }
    func isPasswordValid(_ password:String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: password)
    }
    func isChampValide()->Bool{
        if(self.newPwdTF.text == "" || self.confirmPwdTF.text == ""){
            AlertUtilities.displayAlert("Champs manquants", "Veuillez remplir touus les champs", VC: self)
            return false
        }
        if(!isPasswordValid(self.newPwdTF.text!)){
            AlertUtilities.displayAlert("MOT DE PASSE INVALIDE", "Le mot de passe doit contenir au moins 8 caractère, avec un nombre et une majuscule", VC: self)
            return false
        }
        let pwd = self.newPwdTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPwd = self.confirmPwdTF.text?.trimmingCharacters(in: .whitespacesAndNewlines )
        if(pwd != confirmPwd){
            AlertUtilities.displayAlert("Mot de passe différent", "Veuillez mettre le meme mot de passe", VC: self)
            return false
        }else{
            return true
            
        }
    }
    func setUpSecurity(){
        StyleUtilities.textField(newPwdTF, color: UIColor.black.cgColor,placeholderColor: UIColor.black)
        StyleUtilities.textField(confirmPwdTF, color: UIColor.black.cgColor,placeholderColor: UIColor.black)
        StyleUtilities.roundButton(changePwdBtn)
        StyleUtilities.roundButton(topicPosted)
        StyleUtilities.roundButton(logOutBtn)
        StyleUtilities.roundButton(securityBtn)
        StyleUtilities.roundButton(profilBtn)
    }
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.pushViewController(HomeViewController(), animated: true)
    }
    @IBAction func changePassword(_ sender: Any) {
        if(isChampValide()){
            Auth.auth().currentUser?.updatePassword(to: self.newPwdTF.text!) { error in
                if error != nil {
                    AlertUtilities.displayAlert("Erreur", "Erreur server mot de passe inchangé", VC: self)
                }else{
                    AlertUtilities.displayAlert("MOT DE PASSE CHANGÉ", "Votre mot de passe a été changé", VC: self)
                }
            }
        }
    }
    
    @IBAction func profilTapped(_ sender: Any) {
        self.navigationController?.pushViewController(profilViewController(), animated: false)
    }
    @IBAction func topicTapped(_ sender: Any) {
        self.navigationController?.pushViewController(topicSendViewController(), animated: false)
    }
    @IBAction func logOutTapped(_ sender: Any) {
        UserDefaults.standard.reset()
        let vc = SignInViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
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
