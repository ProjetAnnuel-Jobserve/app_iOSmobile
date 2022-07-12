//
//  addTopicViewController.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 14/05/2022.
//

import UIKit
import FirebaseStorage
import Firebase

class addTopicViewController: UIViewController {

    @IBOutlet weak var topicDescriptionTextVIew: UITextView!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var addTopicButton: UIButtonExtensions!
    @IBOutlet weak var addTopicSubview: UIView!
    
    @IBOutlet weak var topicImgImageView: UIImageView!
    @IBOutlet weak var topicTitleTF: UITextField!
    
    private let storage = Storage.storage().reference()
    private var urlImg : String?
    var userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVC()
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func imagePicker (sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType=sourceType
        return imagePicker
        
    }
    
    func showImagePickerOptions(){
        let alertVC = UIAlertController(title: "Choisir une photo", message: "Choisissez une photo dans votre galerie", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default){[weak self] (action) in
            guard let self = self else{
                return
            }
            let cameraImagePicker = self.imagePicker(sourceType: .camera)
            cameraImagePicker.delegate = self
            self.present(cameraImagePicker, animated: true){
                
            }
            
        }
            let libraryAction = UIAlertAction(title: "Galerie", style: .default){[weak self] (action) in
                guard let self = self else{
                    return
                }
                let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
                libraryImagePicker.delegate = self
                self.present(libraryImagePicker, animated: true){
                    
                }
            }
        let cancelAction = UIAlertAction(title: "Annuler", style: .default,handler: nil)
        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true,completion: nil)
    }
    
    
    
    func setUpVC(){
        StyleUtilities.roundView(addTopicSubview)
        StyleUtilities.roundView(topicImgImageView)
        StyleUtilities.sign(addTopicButton)
        StyleUtilities.sign(addTopicButton)
        topicTitleTF.layer.style = .none
        StyleUtilities.borderColor(topicDescriptionTextVIew)
        topicDescriptionTextVIew.layer.borderWidth = 0.2
    }
    @IBAction func addTopicTapped(_ sender: Any) {
        if (isFieldOk()){
            uploadImageFirebase()
        }
        
    }
    @IBAction func uploadImage(_ sender: Any) {
        showImagePickerOptions()
    }
    
    func isFieldOk()->Bool{
        if(topicTitleTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            AlertUtilities.displayAlert("Champs Manquants", "Le topic n'a pas de titre", VC: self)
            return false
        }else if(topicDescriptionTextVIew.text.trimmingCharacters(in: .whitespacesAndNewlines) == "Description..." || topicDescriptionTextVIew.text.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            AlertUtilities.displayAlert("Champs Manquants", "Le topic n'a pas de description", VC: self)
            return false
        }
        return true
    }
    
    func addTopicApi(){
        print("userId", self.userID!)
        let baseURL = URL(string: "https://jobserve-moc.herokuapp.com/topics/")
        let today = Date.now
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        let thedate = formatter1.string(from: today)
        var request = URLRequest(url: baseURL!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
            let jsonDictionary: [String: Any] = [
            "name": topicTitleTF.text ?? "Pas de Titre ",
            "dateEnded": thedate,
            "description": topicDescriptionTextVIew.text ?? "Pas de description",
            "numberVoteYes": 0,
            "numberVoteNo": 0,
            "status": "1",
            "image": "\(self.urlImg ?? "")",
            "type": "string"
            //A changer
            //"fk_userid": "\(self.userID!)"
            
        ]

        let data = try! JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
        
        URLSession.shared.uploadTask(with: request, from: data) { (responseData, response, error) in
            if let error = error {
                print("Error making POST request: \(error.localizedDescription)")
                return
            }
            
            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
                guard responseCode == 200 else {
                    print("Invalid response code: \(responseCode)")
                    AlertUtilities.displayAlert("Erreur", "Erreur serveur ", VC: self)
                    return
                }
                
                if let responseJSONData = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {
                    print("Response JSON data = \(responseJSONData)")
                    return
                }
                AlertUtilities.displayAlert("Topic ajouté ", "Topic ajouté avec succès ", VC: self)
                
            }
        }.resume()
        
        self.navigationController?.pushViewController(HomeViewController(), animated: true)
    }
    
    func uploadImageFirebase(){
        let today = Date.now
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        let thedate = formatter1.string(from: today).replacingOccurrences(of: "/", with: "_")
        
        guard let imageData = self.topicImgImageView.image?.pngData() else{
            self.urlImg = ""
            addTopicApi()
            return
        }
        storage.child("images/\(thedate)/\(self.topicTitleTF.text!).png").putData(imageData, metadata: nil, completion: {_,error in
            guard error == nil else{
                print("failed to upload")
                return
            }
            self.storage.child("images/\(thedate)/\(self.topicTitleTF.text!).png").downloadURL(completion: {url,error in
                guard let url = url, error == nil else {
                    print("URL IMAGE ERREUR")
                    self.urlImg = ""
                    return
                }
                let urlString = url.absoluteString
                print("URL DOWNLOAD =",urlString)
                self.urlImg = urlString
                self.addTopicApi()
                
            })
        })
    }
}
extension addTopicViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey:Any]){
    let image = info[.originalImage] as! UIImage
    self.topicImgImageView.image = image
    self.dismiss(animated: true, completion: nil)
    }
    
}
