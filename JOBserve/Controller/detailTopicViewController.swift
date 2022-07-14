//
//  detailTopicViewController.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 25/06/2022.
//

import UIKit
import Firebase

class detailTopicViewController: UIViewController {
    
    var selectedTopic: Topic!
    var userID = Auth.auth().currentUser?.uid

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var topicTitle: UILabel!
    @IBOutlet weak var statusTopic: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var alreadyVotedLabel: UILabel!
    @IBOutlet weak var topicDescription: UILabel!
    @IBOutlet weak var choiceView: UIView!
    @IBOutlet weak var imageTopic: UIImageView!
    @IBOutlet weak var resultatLbl: UILabel!
    
    @IBOutlet weak var noLbl: UILabel!
    @IBOutlet weak var yesLbl: UILabel!
    @IBOutlet weak var noResult: UILabel!
    @IBOutlet weak var yesResult: UILabel!
    var currentUser : User?
    
    public class func newInstance(topic: Topic) -> detailTopicViewController{
        let cvc = detailTopicViewController()
        cvc.selectedTopic = topic
        return cvc
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadUser()
        setUpVC()
        
        
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
    
    func setUpVC(){
        let urlImg = URL(string: selectedTopic.image)
        self.imageTopic.kf.setImage(with:urlImg,placeholder: UIImage(named: "placeholderTopic"))
        let str = selectedTopic.dateEnded.components(separatedBy:"T")
        let str1 = str[0]
        topicTitle.text = selectedTopic.name
        topicDescription.text = selectedTopic.description
        if(selectedTopic.status == "2"){
            statusTopic.textColor = UIColor(red: 9/255, green: 122/255, blue: 20/255, alpha: 1)
            statusTopic.text = "OUVERT"
            resultatLbl.isHidden = true
            yesLbl.isHidden = true
            noLbl.isHidden = true
            yesResult.isHidden = true
            noResult.isHidden = true
            self.progressBar.isHidden = true
        }else{
            self.progressBar.isHidden = false
            resultatLbl.isHidden = false
            yesLbl.isHidden = false
            noLbl.isHidden = false
            yesResult.isHidden = false
            noResult.isHidden = false
            statusTopic.textColor = .red
            statusTopic.text = "FERMÉ"
            yesBtn.isEnabled = false
            noBtn.isEnabled = false
            setUpResult()
            yesBtn.alpha = 0.8
            yesBtn.layer.backgroundColor = UIColor.gray.cgColor
            noBtn.alpha = 0.8
            noBtn.layer.backgroundColor = UIColor.gray.cgColor
        }
        if(currentUser != nil){
        if(self.selectedTopic.userVoters.contains(currentUser!._id)){
            alreadyVotedLabel.isHidden = false
            yesBtn.isEnabled = false
            noBtn.isEnabled = false
            StyleUtilities.buttonStyleDisableYesNO(yesBtn)
            StyleUtilities.buttonStyleDisableYesNO(noBtn)
        }else{
            alreadyVotedLabel.isHidden = true
            yesBtn.isEnabled = true
            noBtn.isEnabled = true
        }
        }
        endDateLabel.text = str1
        StyleUtilities.roundView(choiceView)
        StyleUtilities.circleButton(yesBtn)
        StyleUtilities.circleButton(noBtn)
        StyleUtilities.roundView(imageTopic)
        imageTopic.layer.cornerRadius = 25
    }
    
    func setUpResult(){
        let nbVoters = selectedTopic.userVoters.count
        if (nbVoters>0) {
            let nbyes = selectedTopic.numberVoteYes
            let nbno = selectedTopic.numberVoteNo
            if(nbyes > 0 ){
                let yesResult = (nbyes*100)/nbVoters
                self.yesResult.text = "\(yesResult)%"
                self.noResult.text = "\(100-(yesResult))%"
                self.progressBar.progress = Float(yesResult)*0.01
            }else if(nbno > 0){
                let noResult = (nbno*100)/nbVoters
                self.noResult.text = "\(noResult)%"
                self.yesResult.text = "\(100-(noResult))%"
                self.progressBar.progress = Float((100-noResult)/100)
            }
        }else{
            self.progressBar.isHidden = true
            self.noResult.text = "Pas de votes"
            self.yesResult.text = "Pas de votes"
        }
        
        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func noButtonPressed(_ sender: Any) {
        vote(choice: false)
    }
    @IBAction func yesButtonPressed(_ sender: Any) {
        vote(choice: true)
    }
    
    func vote(choice : Bool){
        if(currentUser != nil){
        StyleUtilities.buttonStyleDisableYesNO(yesBtn)
        StyleUtilities.buttonStyleDisableYesNO(noBtn)
        alreadyVotedLabel.isHidden = false
            if (selectedTopic.userVoters.contains(currentUser!._id)) {
            return
        }
        let baseURL = URL(string: "https://jobserve-moc.herokuapp.com/topics")
        var request = URLRequest(url: baseURL!)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        if (choice) {
            selectedTopic.numberVoteYes += 1
        }else{
            selectedTopic.numberVoteNo = 0
        }
        yesBtn.isEnabled = false
        noBtn.isEnabled = false
            selectedTopic.userVoters.append(self.currentUser!._id)
        
        let jsonDictionary: [String: Any] = [
            
            "userVoters": selectedTopic.userVoters,
            "_id": selectedTopic._id,
            "dateEnded": selectedTopic.dateEnded,
            "description": selectedTopic.description,
            "image": selectedTopic.image,
            "name": selectedTopic.name,
            "numberVoteNo": selectedTopic.numberVoteNo,
            "numberVoteYes": selectedTopic.numberVoteYes,
            "status": selectedTopic.status,
            "__v": 0
        ]

        let data = try! JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
        
        URLSession.shared.uploadTask(with: request, from: data) { (responseData, response, error) in
            if let error = error {
                print("Error making PUT request: \(error.localizedDescription)")
                return
            }
            
            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
                guard responseCode == 200 else {
                    print("Invalid response code: \(responseCode)")
                    return
                }
                
                if let responseJSONData = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {
                    print("Response JSON data = \(responseJSONData)")
                }
                
            }
        }.resume()
        AlertUtilities.displayAlert("Vote ok", "Votre vote a été pris en compte", VC: self)
        }
        
    }
}
