//
//  HomeViewController.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 12/05/2022.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    var topicsList : [Topic] = []
    var eventsList : [Event] = []
    var SignINvc : SignInViewController = SignInViewController()
    var topicView = true
    var userID = "d123fd81"
    var tabuser = ["d123fd8","d123d81","d123fd81"]
    @IBOutlet weak var topicsCollectionView: UICollectionView!

    public class func HVCevent() -> HomeViewController{
        let cvc = HomeViewController()
        cvc.topicView = false
        return cvc
    }
    
    
    func parse(json: Data){
        if(topicView){
        let decoder = JSONDecoder()
        
        if let jsonTopics = try? decoder.decode([Topic].self, from: json){
            var TheRecipes:[Topic] = []
            for topic in jsonTopics{
                TheRecipes.append(topic)
            }
            topicsList = TheRecipes
            topicsCollectionView.reloadData()
        }
        else{
           // print(json)
            print("valeur istopic",topicView)
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
                print("valeur istopic",topicView)
                print("Error PArse")
            }
        }
        
    }
    func loadTopics(){
        // A modifier
        var urlApi = "https://jobserve-moc.herokuapp.com/topics"
        if (!topicView){
             urlApi = "https://jobserve-moc.herokuapp.com/events"
        }
        if let url = URL(string: urlApi ){
        if let data = try? Data(contentsOf: url){
            print("valeur avant appel de parse istopic",urlApi)
            parse(json: data)
        }
        }
    }


    @IBOutlet weak var addTopicBtn: UIButton!
    override func viewDidLoad() {
          let theUser = User(firstname: "Zinedine", lastname: "MEGNOUCHE", address: "28 avenue edouard vaillant", city: "Marseille", zipcode: "13003", email: "megnouche.z@gmail.com", phoneNumber: "0634476943")
        //UserDefaults.standard.set(theUser, forKey: "USER")
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(theUser)
            
            UserDefaults.standard.set(data, forKey: "USER")

        } catch {
            print("Unable to Encode Note (\(error))")
        }
        
        super.viewDidLoad()
        setUpVC()
        print("&&&&&Valeur bool isTopic = ",topicView)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
      //  self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setUpVC(){
        //print("id = ",SignINvc.idLogin)
       // let id : String
        //id = SignInViewController.
      //  print("id = ",id)
        loadTopics()
        //topicsMenuBtn.is
        topicsCollectionView.showsHorizontalScrollIndicator = false
        topicsCollectionView.backgroundColor = UIColor(white: 1, alpha: 0)
        topicsCollectionView.delegate = self
        topicsCollectionView.dataSource = self
        topicsCollectionView.showsVerticalScrollIndicator = false
        self.topicsCollectionView.register(UINib(nibName: "topicCVC", bundle: nil), forCellWithReuseIdentifier: "topicCell")
        
       // topicsCollectionView.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        //addTopicBtn.setImage(UIImage(named: "test"), for: .normal)
    }
    @IBAction func addTopicBtnTapped(_ sender: Any) {
        self.navigationController?.pushViewController(addTopicViewController(),animated: true)
    }
    
    @IBAction func profilBtnTapped(_ sender: Any) {
        
        self.navigationController?.pushViewController(profilViewController(), animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(topicView){
        let selectedTopic = self.topicsList[indexPath.row]
        let nextController = detailTopicViewController.newInstance(topic: selectedTopic)
        self.navigationController?.present(nextController, animated: true)
        }else{
            let selectedEvent = self.eventsList[indexPath.row]
            // a changer
            let nextController = detailEventViewController.newInstance(event: selectedEvent)
            self.navigationController?.present(nextController, animated: true)
        }
        //print(selectedTopic.title)
    }
}
extension HomeViewController: UICollectionViewDelegate{
    /*func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedTopic = self.topics[indexPath.item]
        /*let nextController = detailTopicViewController.newInstance(topic: selectedTopic)
        self.navigationController?.present(nextController, animated: true)*/
        print(selectedTopic.title)
    }*/
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
                //cell.topicTitleLabel.textColor = .blue
                //Ceci est un test : A changer
               /* if(topic._id == "2"){
                    cell.isVotedImage.isHidden =  true
                }*/
                let urlImg = URL(string: topic.image)
                cell.topicImage.kf.setImage(with:urlImg,placeholder: UIImage(named: "placeholderTopic"))
                
                
                if(topic.userVoters.contains(userID)){
                     print("deja voté")
                     cell.isVotedImage.isHidden =  false
                     //self.tabuser = []
                 }else{
                     cell.isVotedImage.isHidden =  true
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
                //cell.layer.masksToBounds = false
                cell.layer.shadowPath = CGPath(roundedRect: cell.bounds, cornerWidth: cell.layer.cornerRadius, cornerHeight: 200, transform: nil)
                return cell
            }
            return UICollectionViewCell()
        }else{
            if let cell = topicsCollectionView.dequeueReusableCell(withReuseIdentifier: "topicCell", for: indexPath) as? topicCVC{
                let event = eventsList[indexPath.row]
                
                cell.topicTitleLabel.text = event.name
                //cell.topicTitleLabel.textColor = .blue
                let urlImg = URL(string: event.image)
                cell.topicImage.kf.setImage(with:urlImg,placeholder: UIImage(named: "placeholderEvent"))
                //Ceci est un test : A changer
                // ----------- A modifier -------
                if(event.status == "1"){
                    cell.isVotedImage.isHidden =  false
                }
                //---------
                if(event.status == "2"){
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
                //cell.layer.masksToBounds = false
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
extension UserDefaults {
    enum Keys: String, CaseIterable {
        
        case firstname
        case lastname
        case address
        case city
        case zipcode
        case email
        case phoneNumber
    }
    
    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }
}
