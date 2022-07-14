//
//  detailsEventViewController.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 10/07/2022.
//

import UIKit
import Firebase
import EventKit
import EventKitUI

class detailsEventViewController: UIViewController {


    @IBOutlet weak var avisTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statutLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateEnvent: UILabel!
    @IBOutlet weak var adressBtn: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToCalendarBtn: UIButton!
    @IBOutlet weak var imageEvent: UIImageView!
    @IBOutlet weak var addReviewBtn: UIButton!
    @IBOutlet weak var participationBtn: UIButton!
    @IBOutlet weak var avisLbl: UILabel!
    var isParticipated: Bool = false
    var userID = Auth.auth().currentUser?.uid
    var currentUser: User?
    
    
    
    var selectedEvent: Event!
    public class func newInstance(event: Event) -> detailsEventViewController{
        let cvc = detailsEventViewController()
        cvc.selectedEvent = event
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
        
        let urlImg = URL(string: selectedEvent.image)
        self.imageEvent.kf.setImage(with:urlImg,placeholder: UIImage(named: "placeholderEvent"))
        StyleUtilities.roundViewImgEvent(imageEvent)
        titleLabel.text = selectedEvent.name
        descriptionLabel.text = selectedEvent.description
        var str = selectedEvent.dateEnded.components(separatedBy:"T")
        var str1 = str[0]
        dateEnvent.text = str1
        str = selectedEvent.dateInscription.components(separatedBy:"T")
        str1 = str[0]
        dateLabel.text = str1
        adressBtn.setTitle(selectedEvent.location, for: .normal)
        if(currentUser != nil){
            if(selectedEvent.status == "3" && selectedEvent.participant.contains(currentUser!._id)){
                self.addReviewBtn.isEnabled = true
                self.addReviewBtn.isHidden = false
                
            }else{
                self.addReviewBtn.isEnabled = false
                self.addReviewBtn.isHidden = true
            }
        if(selectedEvent.participant.contains(currentUser!._id)){
            self.isParticipated = true
            StyleUtilities.buttonStyleNoPaticipation(participationBtn)
        }else{
            StyleUtilities.buttonStylePaticipation(participationBtn)
        }
        }
        setUpStatut()
        
        avisTableView.delegate = self
        avisTableView.dataSource = self
        avisTableView.separatorStyle = .none
        avisTableView.showsVerticalScrollIndicator = false
        self.avisTableView.register(UINib(nibName: "AvisTableViewCell", bundle: nil), forCellReuseIdentifier: "avisCell")
    }
    
    func setUpStatut(){
        if(selectedEvent.status == "2"){
            statutLabel.text = "OUVERT"
            statutLabel.textColor = .green
            participationBtn.isEnabled = true
            self.avisTableView.isHidden = true
            avisLbl.isHidden = true
            addToCalendarBtn.isHidden = false
        }else if (selectedEvent.status == "3"){
            addToCalendarBtn.isHidden = true
            avisLbl.isHidden = false
            self.avisTableView.isHidden = false
            statutLabel.text = "FERMÉ"
            statutLabel.textColor = .red
            participationBtn.isEnabled = false
            StyleUtilities.buttonStyleDisable(participationBtn)
        }
        else{
            statutLabel.text = "ERREUR"
            statutLabel.textColor = .black
            participationBtn.isEnabled = false
            StyleUtilities.buttonStyleDisable(participationBtn)
            addToCalendarBtn.isHidden = true
        }
    }

    @IBAction func adressClicked(_ sender: Any) {
       let adr = selectedEvent.location.replacingOccurrences(of: " ", with: ",")
        if let url = URL(string: "http://maps.apple.com/?address=\(adr)"){
             UIApplication.shared.open(url)
         }
    }
    @IBAction func addReview(_ sender: Any) {
        if(selectedEvent.status == "3" && selectedEvent.participant.contains(currentUser!._id)){
            let alertController = UIAlertController(title: "Nouvel avis", message: "Entrez votre commentaire", preferredStyle: .alert)

            alertController.addTextField { (textField) in
                // configure the properties of the text field
                textField.placeholder = "description..."


            // add the buttons/actions to the view controller
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in

                // this code runs when the user hits the "save" button

                let inputName = alertController.textFields![0].text

                if(inputName?.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
                    self.changeEvent(event: self.selectedEvent,addReview: true,review: inputName)
                }

            }

            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)

                self.present(alertController, animated: true, completion: nil)
        }
        }
    }
    @IBAction func addToCalendarTapped(_ sender: Any) {
        addToCalendar()
        AlertUtilities.displayAlert("Evenement Ajouté", "\(self.selectedEvent.name) a été ajouté à votre calendrier ", VC: self)
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func participationClicked(_ sender: Any) {
        if(self.isParticipated){
                        StyleUtilities.buttonStylePaticipation(participationBtn)
            
        }else{
            StyleUtilities.buttonStyleNoPaticipation(participationBtn)
        }
        changeEvent(event: self.selectedEvent)
        isParticipated.toggle()
    }
    
    func changeEvent(event: Event,addReview: Bool? = false,review: String? = ""){
        let baseURL = URL(string: "https://jobserve-moc.herokuapp.com/events")
        var participation : Bool
        if(!self.isParticipated){
            participation = true
        }
        else{
            participation = false
        }

        var request = URLRequest(url: baseURL!)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        if(addReview == false){
        if(currentUser != nil){
        if (participation) {
            self.selectedEvent.participant.append(currentUser!._id)
        }else{
            if let index = self.selectedEvent.participant.firstIndex(of: currentUser!._id) {
                self.selectedEvent.participant.remove(at: index)
            }
        }
        }
            
        }else{
            if(review != ""){
                selectedEvent.review.append(review!)
            }
            
        }
        let jsonDictionary: [String: Any] = [
            
            "participant": self.selectedEvent.participant,
             "review": selectedEvent.review,
             "_id": selectedEvent._id,
             "dateEnded": selectedEvent.dateEnded,
             "dateInscription": selectedEvent.dateInscription,
             "description": selectedEvent.description,
             "image": selectedEvent.image,
             "location": selectedEvent.location,
             "name": selectedEvent.name,
             "status": selectedEvent.status,
             "__v": 0,
            
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
    }
    
    func addToCalendar(){
        let eventStore : EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
          
          if (granted) && (error == nil) {
              print("granted \(granted)")
              print("error \(String(describing: error))")
              
              let event:EKEvent = EKEvent(eventStore: eventStore)
              let str = self.selectedEvent.dateEnded.components(separatedBy:"T")
              let str1 = str[0]
              let dateEvent = str1
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "yyyy-MM-dd"
              let date = dateFormatter.date(from:dateEvent)!
              event.title = self.selectedEvent.name
              event.startDate = date
              event.endDate = date
              event.notes = self.selectedEvent.description
              event.isAllDay = true
              event.location = self.selectedEvent.location
              event.calendar = eventStore.defaultCalendarForNewEvents
              do {
                        try eventStore.save(event, span: .thisEvent)
                    } catch let error as NSError {
                        print("failed to save event with error : \(error)")
                    }
                    print("Saved Event")
                }
            else{
                }
              }
    }
    
}
extension detailsEventViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.selectedEvent.review.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = avisTableView.dequeueReusableCell(withIdentifier: "avisCell", for: indexPath) as? AvisTableViewCell{
            let avis = self.selectedEvent.review[indexPath.row]
            
            cell.avislabel.text = avis
            return cell
        }
        return UITableViewCell()
    }

}
