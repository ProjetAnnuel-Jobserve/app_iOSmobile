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
    
    //var idLogin : String?
    /*var idLogin:String{
        get{
            return _idLogin
        }
    }*/
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        if alreadyConnected() == true {
            self.transitionToHome()
        }
        super.viewDidLoad()
        setUpVC()

        // Do any additional setup after loading the view.
    }
    
    func setUpVC(){
        StyleUtilities.sign(signInBtn)
        StyleUtilities.textField(usernameTF,color: UIColor.white.cgColor)
        StyleUtilities.textField(passwordTF,color: UIColor.white.cgColor)
        //self.navigationController?.tabBarController?.tabBar.isHidden = true
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
    func alreadyConnected() -> Bool {
        if (defaults.string(forKey: "uid") != nil) {
            return true
        }
        return false
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonTopics = try? decoder.decode([User].self, from: json){
            for user in jsonTopics{
                if(user.email == usernameTF.text){
                    let theUser = User(firstname: user.firstname, lastname: user.lastname, address: user.address, city: user.city, zipcode: user.city, email: user.email, phoneNumber: user.phoneNumber)
                    let defaults = UserDefaults.standard
                    defaults.set(theUser, forKey: "USER")
                    continue
                }
                //Users.append(user)
            }
            //topicsCollectionView.reloadData()
           // print("RecipeList---------\(recipeslist.description)")
        }
        else{
            print("Error PArse")
        }
    }
    func getUser(){
        if let url = URL(string: "https://jobserve-moc.herokuapp.com/users"){
        if let data = try? Data(contentsOf: url){
            parse(json: data)
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
       // self.idLogin = " Ma bite "
       // getUser()
      //  sender.flash()
       // self.navigationController?.tabBarController?.tabBar.isHidden = false
       // transitionToHome()
        
        //-----------------------------
        print("SigniNTAPED")
        let email = self.usernameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let pwd = self.passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (!isChampsValide(email: email, pwd: pwd)) {
            print("champs invalide")
            return
        }
        else{
            Auth.auth().signIn(withEmail: email, password: pwd) { (result, error) in
                if error != nil {
                    AlertUtilities.displayAlert("Erreur d'authentification", "Adresse mail ou mot de passe incorrect", VC: self)
                    print("erreu authentifiaction")
                } else {
                    guard let userID = Auth.auth().currentUser?.uid else { return }
                    print("User id =",userID)
                    self.defaults.set(userID, forKey: "userID")
                    print("authentification ok ")
                    self.transitionToHome()
                }
            }
            //transitionToHome()
        }
        
       
    }
    
    func transitionToHome(){
        defaults.synchronize()
        self.navigationController?.pushViewController(MainTabBarController(),animated: true)
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
