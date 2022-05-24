//
//  addTopicViewController.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 14/05/2022.
//

import UIKit

class addTopicViewController: UIViewController {

    @IBOutlet weak var topicDescriptionTextVIew: UITextView!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var addTopicButton: UIButtonExtensions!
    @IBOutlet weak var addTopicSubview: UIView!
    
    @IBOutlet weak var topicImgImageView: UIImageView!
    @IBOutlet weak var topicTitleTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVC()

        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpVC(){
        StyleUtilities.roundView(addTopicSubview)
        StyleUtilities.sign(addTopicButton)
        //imageLabel.isHidden = true
        topicTitleTF.layer.style = .none
        StyleUtilities.borderColor(topicDescriptionTextVIew)
        topicDescriptionTextVIew.layer.borderWidth = 3
        let firstColor = UIColor(red: 249/255, green: 200/255, blue: 35/255, alpha: 255/255).cgColor
        let secondColor = UIColor(red: 252/255, green: 80/255, blue: 110/255, alpha: 255/255).cgColor
        
        //topicDescriptionTextVIew.layer.borderColor = gradi
    }
    @IBAction func addTopicTapped(_ sender: Any) {
    }
    @IBAction func uploadImage(_ sender: Any) {
    }
}
