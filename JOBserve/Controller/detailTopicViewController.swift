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
        alreadyVotedLabel.isHidden = true
        
        //statusTopic.text = "teeeeest"
        endDateLabel.text = str1
        StyleUtilities.roundView(choiceView)
        StyleUtilities.circleButton(yesBtn)
        StyleUtilities.circleButton(noBtn)
        //choiceView.layer.cornerRadius = 25
        StyleUtilities.roundView(imageTopic)
        imageTopic.layer.cornerRadius = 25
    }
    

    @IBAction func noButtonPressed(_ sender: Any) {
    }
    @IBAction func yesButtonPressed(_ sender: Any) {
    }
    
}
