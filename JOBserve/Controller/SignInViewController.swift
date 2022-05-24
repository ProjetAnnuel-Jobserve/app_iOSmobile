//
//  LoginViewController.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 12/05/2022.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVC()

        // Do any additional setup after loading the view.
    }
    
    func setUpVC(){
        StyleUtilities.sign(signInBtn)
        StyleUtilities.textField(usernameTF)
        StyleUtilities.textField(passwordTF)
    }
    
    @IBAction func forgetpwdtapped(_ sender: Any) {
    }
    
    
    
    @IBAction func signInTapped(_ sender: UIButtonExtensions) {
        sender.flash()
        transitionToHome()
       /* let username = self.usernameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let pwd = self.passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if username == "" || pwd == "" {
            AlertUtilities.displayAlert("Missing Fields ", "Please fill all informations", VC: self)
        }
        else{
            transitionToHome()
        }*/
        
       
    }
    
    func transitionToHome(){
        self.navigationController?.pushViewController(HomeViewController(),animated: true)
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
