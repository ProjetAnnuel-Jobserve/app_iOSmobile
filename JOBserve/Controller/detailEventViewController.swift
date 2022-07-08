//
//  detailEventViewController.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 28/06/2022.
//

import UIKit

class detailEventViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statutLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateEnvent: UILabel!
    @IBOutlet weak var adressBtn: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageEvent: UIImageView!
    @IBOutlet weak var participationBtn: UIButton!
    @IBOutlet weak var viewImage: UIView!
    var isParticipated: Bool = false
    
    
    
    var selectedEvent: Event!
    public class func newInstance(event: Event) -> detailEventViewController{
        let cvc = detailEventViewController()
        cvc.selectedEvent = event
        return cvc
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
        StyleUtilities.roundView(viewImage)
        StyleUtilities.buttonStylePaticipation(participationBtn)
        titleLabel.text = selectedEvent.name
        setUpStatut()
        descriptionLabel.text = selectedEvent.description
        var str = selectedEvent.dateEnded.components(separatedBy:"T")
        var str1 = str[0]
        dateEnvent.text = str1
        str = selectedEvent.dateInscription.components(separatedBy:"T")
        str1 = str[0]
        dateLabel.text = str1
       // dateLabel.text = selectedEvent.
        //adressBtn.titleLabel = selectedEvent.
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
       // let adr = selectedEvent..replacingOccurrences(of: " ", with: ",")
        if let url = URL(string: "http://maps.apple.com/?address=28,rue,faubourg,Saint-Antoine,PARIS"){
            UIApplication.shared.open(url)
        }
        //openURL(URL(string: ""))
    }
    @IBAction func participationClicked(_ sender: Any) {
        if(self.isParticipated){
            StyleUtilities.buttonStylePaticipation(participationBtn)
        }else{
            StyleUtilities.buttonStyleNoPaticipation(participationBtn)
        }
        isParticipated.toggle()
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
