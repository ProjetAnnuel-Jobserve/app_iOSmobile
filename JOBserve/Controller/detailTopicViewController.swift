//
//  detailTopicViewController.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 25/06/2022.
//

import UIKit

class detailTopicViewController: UIViewController {
    
    var selectedTopic: Topic!

    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var topicTitle: UILabel!
    @IBOutlet weak var statusTopic: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var alreadyVotedLabel: UILabel!
    @IBOutlet weak var topicDescription: UILabel!
    @IBOutlet weak var choiceView: UIView!
    @IBOutlet weak var imageTopic: UIImageView!
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
        //self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpVC()
        
        
    }
    func setUpVC(){
        let urlImg = URL(string: selectedTopic.image)
        self.imageTopic.kf.setImage(with:urlImg,placeholder: UIImage(named: "placeholderTopic"))
        //StyleUtilities.roundView(imageTopic)
        let str = selectedTopic.dateEnded.components(separatedBy:"T")
        let str1 = str[0]
        topicTitle.text = selectedTopic.name
        topicDescription.text = selectedTopic.description
        if(selectedTopic.status == "2"){
            statusTopic.textColor = UIColor(red: 9/255, green: 122/255, blue: 20/255, alpha: 1)
            statusTopic.text = "OUVERT"
        }else{
            statusTopic.textColor = .red
            statusTopic.text = "FERMÉ"
            yesBtn.isEnabled = false
            noBtn.isEnabled = false
            yesBtn.alpha = 0.8
            yesBtn.layer.backgroundColor = UIColor.gray.cgColor
            noBtn.alpha = 0.8
            noBtn.layer.backgroundColor = UIColor.gray.cgColor
        }
        /*
         Ajouter condition deja voté
         */
        if(self.selectedTopic.userVoters.contains("Zizou")){
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
        
        //statusTopic.text = "teeeeest"
        endDateLabel.text = str1
        StyleUtilities.roundView(choiceView)
        StyleUtilities.circleButton(yesBtn)
        StyleUtilities.circleButton(noBtn)
        //choiceView.layer.cornerRadius = 25
        StyleUtilities.roundView(imageTopic)
        imageTopic.layer.cornerRadius = 25
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
        //A changer
        StyleUtilities.buttonStyleDisableYesNO(yesBtn)
        StyleUtilities.buttonStyleDisableYesNO(noBtn)
        alreadyVotedLabel.isHidden = false
        if (selectedTopic.userVoters.contains("Zizou")) {
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
            //StyleUtilities.buttonStyleDisable(noBtn)
        }else{
            //StyleUtilities.buttonStyleDisable(yesBtn)
            selectedTopic.numberVoteNo += 1
            //print("Nb no =",selectedTopic.numberVoteNo)
        }
        yesBtn.isEnabled = false
        noBtn.isEnabled = false
        print("user voter:",selectedTopic.userVoters)
        print("id:",selectedTopic._id)
        print("date ended:",selectedTopic.dateEnded)
        print("desc:",selectedTopic.description)
        print("img:",selectedTopic.image)
        print("name:",selectedTopic.name)
        print("Yes:",selectedTopic.numberVoteYes)
        print("NO:",selectedTopic.numberVoteNo)
        print("statu:",selectedTopic.status)
        self.selectedTopic.userVoters.append("Zizou")
        
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

/*
 {
     "_id": "62c5cc6924dfa30016a524d5",
     "firstname": "Tom",
     "lastname": "Sav",
     "birthDate": "2021-02-03T00:00:00.000Z",
     "location": "Paris",
     "email": "app1234@group.fr",
     "phoneNumber": "0623532353",
     "password": "testtest",
     "job": "Commercial",
     "permission": "user",
     "fk_company": "2",
     "idFirebase": "WZWbzyauzYhSsBx1P4dKL5WqlDN2",
     "__v": 0
 }
 */
