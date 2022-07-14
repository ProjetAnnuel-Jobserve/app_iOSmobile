//
//  topicSendViewController.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 25/05/2022.
//

import UIKit
import Firebase

class topicSendViewController: UIViewController {
    
    @IBOutlet weak var topicView: UIView!
    
    
    @IBOutlet weak var profilBtn: UIButton!
    @IBOutlet weak var securityBtn: UIButton!
    @IBOutlet weak var topicBtn: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!
    
    @IBOutlet weak var topicSendedTableView: UITableView!
    var userID = Auth.auth().currentUser?.uid
    var currentUser :User?
    var topicsSended : [Topic] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTopic()
    }

    func parseUser(json: Data){
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
            parseUser(json: data)
        }
        }
    }
    
    func parseTopic(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonTopics = try? decoder.decode([Topic].self, from: json){
            var topics:[Topic] = []
            for topic in jsonTopics{
                if(topic.fk_userid == currentUser!._id){
                    topics.append(topic)
                    
                }
            }
            topicsSended = topics
            print("Topic sned= ",topicsSended)
            topicSendedTableView.reloadData()
        }
        
    }
    func loadTopic(){
        // A modifier
        if(currentUser != nil){
        let urlApi = "https://jobserve-moc.herokuapp.com/topics"
        if let url = URL(string: urlApi ){
        if let data = try? Data(contentsOf: url){
            parseTopic(json: data)
        }
        }
        }
    }
    
    func setUpTopic(){
        loadUser()
        loadTopic()
        StyleUtilities.roundView(topicView)
        StyleUtilities.roundButton(topicBtn)
        StyleUtilities.roundButton(logOutBtn)
        StyleUtilities.roundButton(securityBtn)
        StyleUtilities.roundButton(profilBtn)
        topicSendedTableView.layer.cornerRadius = 16
        topicSendedTableView.backgroundColor = .clear
        topicSendedTableView.delegate = self
        topicSendedTableView.dataSource = self
        topicSendedTableView.separatorStyle = .none
        topicSendedTableView.showsVerticalScrollIndicator = false
        self.topicSendedTableView.register(UINib(nibName: "topicsSendedTableViewCell", bundle: nil), forCellReuseIdentifier: "topicSendedCell")
        
        print(self.topicsSended)
    }
    

    @IBAction func profilTapped(_ sender: Any) {
        self.navigationController?.pushViewController(profilViewController(), animated: false)
    }
    @IBAction func securityTapped(_ sender: Any) {
        self.navigationController?.pushViewController(securityViewController(), animated: false)
    }
    @IBAction func logOutTapped(_ sender: Any) {
        let vc = SignInViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.pushViewController(HomeViewController(), animated: true)
    }

}
extension topicSendViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.topicsSended.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = topicSendedTableView.dequeueReusableCell(withIdentifier: "topicSendedCell", for: indexPath) as? topicsSendedTableViewCell{
            let statut = topicsSended[indexPath.row].status
            if(statut == "1"){
                cell.statutLbl.text =  "En attente"
                cell.statutLbl.textColor = .orange
            }else if(statut == "2"){
                
                cell.statutLbl.text = "Accepté"
                cell.statutLbl.textColor = .green
            }else if(statut == "4"){
                cell.statutLbl.text = "Refusé"
                cell.statutLbl.textColor = .red
            }
            cell.titleTopicLbl.text = topicsSended[indexPath.row].name
            return cell
        }
        return UITableViewCell()
    }

}
