//
//  HomeViewController.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 12/05/2022.
//

import UIKit
import Firebase
import Kingfisher

class HomeViewController: UIViewController {
    var topicsList : [Topic] = []
    var eventsList : [Event] = []
    var SignINvc : SignInViewController = SignInViewController()
    var topicView = true
    var userID = Auth.auth().currentUser?.uid
    var currentUser : User?
    
    @IBOutlet weak var topicsCollectionView: UICollectionView!

    public class func HVCevent() -> HomeViewController{
        let cvc = HomeViewController()
        cvc.topicView = false
        return cvc
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
        let urlApi = "https://jobserve-moc.herokuapp.com/users-firebase/\(self.userID!)"
        if let url = URL(string: urlApi ){
        if let data = try? Data(contentsOf: url){
            parseUser(json: data)
        }
        }
    }
    
    
    func parse(json: Data){
        if(topicView){
        let decoder = JSONDecoder()
        
        if let jsonTopics = try? decoder.decode([Topic].self, from: json){
            var topics:[Topic] = []
            for topic in jsonTopics{
                topics.append(topic)
            }
            topicsList = topics
            topicsCollectionView.reloadData()
        }
        else{
            print("Error PArse")
        }
        }else{
            let decoder = JSONDecoder()
            if let jsonEvents = try? decoder.decode([Event].self, from: json){
                var events:[Event] = []
                for event in jsonEvents{
                    events.append(event)
                }
                eventsList = events
                topicsCollectionView.reloadData()
            }
            else{
                print("Error PArse")
            }
        }
        
    }
    func loadTopics(){
        // A modifier
        if(currentUser != nil){
        var urlApi = "https://jobserve-moc.herokuapp.com/accessible-topics/\(self.currentUser!.fk_company)"
        if (!topicView){
            urlApi = "https://jobserve-moc.herokuapp.com/accessible-events/\(self.currentUser!.fk_company)"
        }
        if let url = URL(string: urlApi ){
        if let data = try? Data(contentsOf: url){
            parse(json: data)
        }
        }
            
        }
    }
    
    @IBOutlet weak var addTopicBtn: UIButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        setUpVC()
    }
    
    func setUpVC(){
        loadUser()
        loadTopics()
        topicsCollectionView.showsHorizontalScrollIndicator = false
        topicsCollectionView.backgroundColor = UIColor(white: 1, alpha: 0)
        topicsCollectionView.delegate = self
        topicsCollectionView.dataSource = self
        topicsCollectionView.showsVerticalScrollIndicator = false
        self.topicsCollectionView.register(UINib(nibName: "topicCVC", bundle: nil), forCellWithReuseIdentifier: "topicCell")
    }
    @IBAction func addTopicBtnTapped(_ sender: Any) {
        self.navigationController?.pushViewController(addTopicViewController(),animated: true)
    }
    
    @IBAction func profilBtnTapped(_ sender: Any) {
        
        self.navigationController?.pushViewController(profilViewController(), animated: true)
    }
    @IBAction func reloadTapped(_ sender: Any) {
        loadTopics()
        topicsCollectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(topicView){
        let selectedTopic = self.topicsList[indexPath.row]
        let nextController = detailTopicViewController.newInstance(topic: selectedTopic)
        self.navigationController?.pushViewController(nextController, animated: true)
        }else{
            let selectedEvent = self.eventsList[indexPath.row]
            // a changer
            let nextController = detailsEventViewController.newInstance(event: selectedEvent)
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
}
extension HomeViewController: UICollectionViewDelegate{
}
extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(topicView){
            return self.topicsList.count
        }
        else{
            return self.eventsList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(topicView){
            if let cell = topicsCollectionView.dequeueReusableCell(withReuseIdentifier: "topicCell", for: indexPath) as? topicCVC{
                let topic = topicsList[indexPath.row]
                
                cell.topicTitleLabel.text = topic.name
                let urlImg = URL(string: topic.image)
                cell.topicImage.kf.setImage(with:urlImg,placeholder: UIImage(named: "placeholderTopic"))
                if(currentUser != nil){
                    if(topic.userVoters.contains(currentUser!._id)){
                     cell.isVotedImage.isHidden =  false
                 }else{
                     cell.isVotedImage.isHidden =  true
                 }
        
                }
                if(topic.status == "3"){
                    cell.statusLabel.textColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
                    cell.statusLabel.text = "FERMÉ"
                    
                }else if(topic.status == "2"){
                    cell.statusLabel.textColor = .green
                    cell.statusLabel.text = "OUVERT"
                }else{
                    cell.statusLabel.textColor = .black
                    cell.statusLabel.text = "NULL"
                }
                cell.layer.cornerRadius = 20
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.white.cgColor
                cell.layer.masksToBounds = true
                cell.layer.shadowColor = UIColor.black.cgColor
                cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
                cell.layer.shadowRadius = 2.0
                cell.layer.shadowOpacity = 0.5
                cell.layer.shadowPath = CGPath(roundedRect: cell.bounds, cornerWidth: cell.layer.cornerRadius, cornerHeight: 200, transform: nil)
                return cell
            }
            return UICollectionViewCell()
        }else{
            if let cell = topicsCollectionView.dequeueReusableCell(withReuseIdentifier: "topicCell", for: indexPath) as? topicCVC{
                let event = eventsList[indexPath.row]
                
                cell.topicTitleLabel.text = event.name
                let urlImg = URL(string: event.image)
                cell.topicImage.kf.setImage(with:urlImg,placeholder: UIImage(named: "placeholderEvent"))
                if(currentUser != nil){
                    if(event.participant.contains(currentUser!._id)){
                    cell.isVotedImage.isHidden =  false
                }else{
                    cell.isVotedImage.isHidden = true
                }
                    
                }
                if(event.status == "3"){
                    cell.statusLabel.textColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
                    cell.statusLabel.text = "EXPIRÉ"
                    }
                else{
                    cell.statusLabel.textColor = .green
                    cell.statusLabel.text = "OUVERT"
                }
                cell.layer.cornerRadius = 20
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.white.cgColor
                cell.layer.masksToBounds = true
                cell.layer.shadowColor = UIColor.black.cgColor
                cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
                cell.layer.shadowRadius = 2.0
                cell.layer.shadowOpacity = 0.5
                cell.layer.shadowPath = CGPath(roundedRect: cell.bounds, cornerWidth: cell.layer.cornerRadius, cornerHeight: 200, transform: nil)
                return cell
            }
            return UICollectionViewCell()
        }
        
    }
    
    
}
extension HomeViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            let Swidth = UIScreen.main.bounds.width - 25
            return CGSize(width: Swidth, height: 200)
        }
     func collectionView(_ collectionView: UICollectionView,
                                   layout collectionViewLayout: UICollectionViewLayout,
                                   minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 15
        }

    func collectionView(_ collectionView: UICollectionView,
                                   layout collectionViewLayout: UICollectionViewLayout,
                                   minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 20
        }
    
}
