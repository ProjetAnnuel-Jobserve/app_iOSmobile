//
//  HomeViewController.swift
//  JOBserve
//
//  Created by Zinedine Megnouche on 12/05/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var topicsCollectionView: UICollectionView!
    let topic1 = Topic(id: "1", title: "Café ?", description: "Voulez-vous un café ?", image: UIImage(systemName: "bolt.horizontal.circle.fill")!)
    let topic2 = Topic(id: "2", title: "THé ?", description: "Du thé alors ?", image: UIImage(systemName: "eye.circle.fill")!)
    
    let topics = [Topic(id: "1", title: "Café ?", description: "Voulez-vous un café ?", image: UIImage(systemName: "bolt.horizontal.circle.fill")!),Topic(id: "2", title: "THé ?", description: "Du thé alors ?", image: UIImage(systemName: "eye.circle.fill")!),Topic(id: "2", title: "THé ?", description: "Du thé alors ?", image: UIImage(systemName: "eye.circle.fill")!),Topic(id: "2", title: "THé ?", description: "Du thé alors ?", image: UIImage(systemName: "eye.circle.fill")!),Topic(id: "2", title: "THé ?", description: "Du thé alors ?", image: UIImage(systemName: "eye.circle.fill")!),Topic(id: "2", title: "THé ?", description: "Du thé alors ?", image: UIImage(systemName: "eye.circle.fill")!),Topic(id: "2", title: "THé ?", description: "Du thé alors ?", image: UIImage(systemName: "eye.circle.fill")!)]
    

    @IBOutlet weak var addTopicBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVC()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setUpVC(){
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
extension HomeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
}
extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = topicsCollectionView.dequeueReusableCell(withReuseIdentifier: "topicCell", for: indexPath) as? topicCVC{
            let topic = topics[indexPath.row]
            
            cell.topicTitleLabel.text = topic.description
            
            cell.topicImage.image = UIImage(named: "test")
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
extension HomeViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            return CGSize(width: 200.0, height: 300.0)
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
