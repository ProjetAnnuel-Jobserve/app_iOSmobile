//
//  detailsEventViewController.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 10/07/2022.
//

import UIKit
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
    @IBOutlet weak var imageEvent: UIImageView!
    @IBOutlet weak var participationBtn: UIButton!
    var isParticipated: Bool = false
    
    
    
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
        //self.navigationItem.setHidesBackButton(true, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVC()
        // Do any additional setup after loading the view.
    }

    func setUpVC(){
       // print("l'id = ",)
        let urlImg = URL(string: selectedEvent.image)
        self.imageEvent.kf.setImage(with:urlImg,placeholder: UIImage(named: "placeholderEvent"))
        StyleUtilities.roundView(imageEvent)
        //StyleUtilities.buttonStylePaticipation(participationBtn)
        titleLabel.text = selectedEvent.name
        
        descriptionLabel.text = selectedEvent.description
        var str = selectedEvent.dateEnded.components(separatedBy:"T")
        var str1 = str[0]
        dateEnvent.text = str1
        str = selectedEvent.dateInscription.components(separatedBy:"T")
        str1 = str[0]
        dateLabel.text = str1
       // dateLabel.text = selectedEvent.
        adressBtn.setTitle(selectedEvent.location, for: .normal)
        if(selectedEvent.participant.contains("Zizou")){
            print("il participe")
            self.isParticipated = true
            StyleUtilities.buttonStyleNoPaticipation(participationBtn)
        }else{
            StyleUtilities.buttonStylePaticipation(participationBtn)
        }
        setUpStatut()
        
        avisTableView.delegate = self
        avisTableView.dataSource = self
        avisTableView.separatorStyle = .none
        avisTableView.showsVerticalScrollIndicator = false
        //changer TVC
        self.avisTableView.register(UINib(nibName: "AvisTableViewCell", bundle: nil), forCellReuseIdentifier: "avisCell")
    }
    
    func setUpStatut(){
        print("statut =",selectedEvent.status)
        if(selectedEvent.status == "1"){
            statutLabel.text = "OUVERT"
            statutLabel.textColor = .green
            participationBtn.isEnabled = true
        }else if (selectedEvent.status == "2"){
            statutLabel.text = "FERMÉ"
            statutLabel.textColor = .red
            participationBtn.isEnabled = false
            StyleUtilities.buttonStyleDisable(participationBtn)
        }
        else{
            statutLabel.text = "ERREUR"
            statutLabel.textColor = .black
        }
    }

    @IBAction func adressClicked(_ sender: Any) {
        print("click sur bouton adresse")
        //URL(string: <#T##String#>)
       // openURL("maps")
       let adr = selectedEvent.location.replacingOccurrences(of: " ", with: ",")
       /* if let url = URL(string: "http://maps.apple.com/?address=28,rue,faubourg,Saint-Antoine,PARIS"){
            UIApplication.shared.open(url)
        }*/
        if let url = URL(string: "http://maps.apple.com/?address=\(adr)"){
             UIApplication.shared.open(url)
         }
        //addToCalendar()
        //openURL(URL(string: ""))
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func participationClicked(_ sender: Any) {
        if(self.isParticipated){
                        StyleUtilities.buttonStylePaticipation(participationBtn)
            print("il ne participe plus")
            print("participation = ",self.isParticipated)
            
        }else{
            StyleUtilities.buttonStyleNoPaticipation(participationBtn)
            print("il participe 1")
            print("participation = ",self.isParticipated)
        }
        changeParticipation(event: self.selectedEvent)
        isParticipated.toggle()
        print("Zebi")
        //self.navigationController?.popViewController(animated: true)
       // self.navigationController?.popViewController(animated: true)
    }
    
    func changeParticipation(event: Event){
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
        if (participation) {
            self.selectedEvent.participant.append("Zizou")
        }else{
            if let index = self.selectedEvent.participant.firstIndex(of: "Zizou") {
                self.selectedEvent.participant.remove(at: index)
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
              
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'

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
                //AlertUtilities.displayAlert("Evenement ajouté", "L'évenement : \"\(self.selectedEvent.name)\" a été ajouté a votre calendrier", VC: self)
               //     print("failed to save event with error : \(error) or access not granted")
                }
              }
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
