//
//  MypageViewController.swift
//  BookManagementApp
//
//  Created by Gomi Kouki on 2023/11/12.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class MypageViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var BookView: UICollectionView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var mailText: UILabel!
    
    let user = Auth.auth().currentUser
    let uid = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    var documents:[DocumentSnapshot] = []
    let storage = Storage.storage()
    var reference:StorageReference
    var documentID = "0JM8tPv49e8lDqUtZ6tu"
    var BookTitle = ""
    var BookIdentifer = "BookLent"
    
    required init?(coder aDecoder: NSCoder) {
        self.reference = self.storage.reference()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        configureRefleshControl()
        imageSet()
        getDocuments()
        profileName.text = user?.displayName
        mailText.text = user?.email
        BookView.delegate = self
        BookView.dataSource = self
        BookView.register(UINib(nibName: "BookCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BookCell")
    }
     
    
    func imageSet(){
        let photoURL = (self.user?.photoURL)!
        
        URLSession.shared.dataTask(with: photoURL){(data,respons,error) in
            if let error = error{
                print(error)
                return
            }
            
            if let imageData = data,let image = UIImage(data: imageData){
                DispatchQueue.main.async {
                    self.profileImage.image = image
                }
            }
        }.resume()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BookLent" {
            let VC = segue.destination as? BookLentViewController
            VC?.BookTitleText = self.BookTitle
        }
        if segue.identifier == "BookLend" {
            let VC = segue.destination as? BookLendViewController
            VC?.BookTitleText = self.BookTitle
        }
    }
    
    
    func getDocuments(){
        db.collection("Book").whereField("lend", isEqualTo: uid!).order(by: "time", descending: false).getDocuments { QuerySnapshot, Error in
            if let Error = Error{
                print(Error)
            }
            if let documets = QuerySnapshot?.documents{
                self.documents = documets
                self.BookView.reloadData()
            }
        }
    }
    
    func getLentDocument(){
        db.collection("Book").whereField("lent", arrayContains: uid!).order(by: "time", descending: false).getDocuments { QuerySnapshot, Error in
            if let Error = Error{
                print(Error)
            }
            if let documents = QuerySnapshot?.documents{
                self.documents = documents
                self.BookView.reloadData()
            }
        }
    }
    
    @IBAction func ValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            getDocuments()
            BookIdentifer = "BookLent"
        case 1:
            getLentDocument()
            BookIdentifer = "BookLend"
        default:
            break
        }
    }
    
    func configureRefleshControl(){
        BookView.refreshControl = UIRefreshControl()
        BookView.refreshControl?.addTarget(self, action: #selector(handleRefleshControl), for: .valueChanged)
    }
    
    @objc func handleRefleshControl(){
        if BookIdentifer == "BookLent"{
            getDocuments()
        }else{
            getLentDocument()
        }
        BookView.refreshControl?.endRefreshing()
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "Login", sender: nil)
        }catch let signOuntError as NSError{
            print(signOuntError)
        }
    }
    
}

extension MypageViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = BookView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCollectionViewCell
        
        cell.BookImage.image = UIImage(systemName: "book")
        
        let data = documents[indexPath.row].data()
        self.documentID = documents[indexPath.row].documentID
        cell.BookTitle.text = data?["title"] as? String
        cell.BookGenre.text = data?["genre"] as? String
        
        let gsReference = storage.reference(withPath: "gs://[BookApp].appspot.com/test/\(documentID).png")
        gsReference.getData(maxSize:  1 * 1024 * 1024) { Data, Error in
            if let Error = Error {
                print(Error)
            }else{
                cell.BookImage.image = UIImage(data: Data!)
                cell.BookImage.alpha = 0.0
                UIView.animate(withDuration: 1.5) {
                    cell.BookImage.alpha = 1.0
                }
            }
        }
        
        return cell
    }
}

extension MypageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedCell = BookView.cellForItem(at: indexPath) as? BookCollectionViewCell{
            self.BookTitle = selectedCell.BookTitle.text!
        }
        performSegue(withIdentifier: BookIdentifer , sender: nil)
    }
}


