//
//  LoginViewController.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 12/05/2022.
//

import UIKit
import Firebase
class SignInViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVC()
    }
    
    func setUpVC(){
        StyleUtilities.sign(signInBtn)
        StyleUtilities.textField(usernameTF,color: UIColor.white.cgColor)
        StyleUtilities.textField(passwordTF,color: UIColor.white.cgColor)
    }
    
    @IBAction func forgetpwdtapped(_ sender: Any) {
        if(usernameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            AlertUtilities.displayAlert("Champ manquant", "Veuillez marquer votre adresse mail", VC: self)
            return
        }
        Auth.auth().sendPasswordReset(withEmail: self.usernameTF.text!) { error in
            if(error == nil){
                AlertUtilities.displayAlert("Reinitalisation de mot de passe", "Un email de réinitialisation de mot de passe à été envoyé à \(self.usernameTF.text!)", VC: self)
            }
            else{
                AlertUtilities.displayAlert("Erreur mail", "L'email: \(self.usernameTF.text!) n'a pas de compte", VC: self)
                print("error sent mail")
            }
        }
    }
    func isChampsValide(email:String,pwd:String)->Bool{
        if email == "" || pwd == "" {
            AlertUtilities.displayAlert("Champs manquants ", "Veuillez remplir tous les champs", VC: self)
            return false
        }
        return true
    }
    @IBAction func signInTapped(_ sender: UIButtonExtensions) {
        let email = self.usernameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let pwd = self.passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (!isChampsValide(email: email, pwd: pwd)) {
            return
        }
        else{
            Auth.auth().signIn(withEmail: email, password: pwd) { (result, error) in
                if error != nil {
                    AlertUtilities.displayAlert("Erreur d'authentification", "Adresse mail ou mot de passe incorrect", VC: self)
                } else {
                    guard let userID = Auth.auth().currentUser?.uid else { return }
                    self.transitionToHome()
                }
            }
        }
        
       
    }
    
    func transitionToHome(){
        self.navigationController?.pushViewController(MainTabBarController(),animated: true)
    }

}
