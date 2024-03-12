//
//  BookLendViewController.swift
//  BookManagementApp
//
//  Created by Gomi Kouki on 2023/11/13.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class BookLendViewController: UIViewController {
    
    
    @IBOutlet weak var BookName: UILabel!
    @IBOutlet weak var BookTitle: UILabel!
    @IBOutlet weak var AuthorName: UILabel!
    @IBOutlet weak var GenreText: UILabel!
    @IBOutlet weak var overviewText: UILabel!
    @IBOutlet weak var BookImage:
    UIImageView!
    @IBOutlet weak var LendButton: UIButton!
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var reference:StorageReference
    let uid = Auth.auth().currentUser?.uid
    
    var BookTitleText = ""
    var documentID = ""
    var lendCheckBool = false

    
    required init?(coder aDecoder: NSCoder) {
        self.reference = self.storage.reference()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(BookTitleText)
        getDocument()
    }
    
    
    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func LendButton(_ sender: Any) {
        if lendCheckBool == false{
            setName()
            dismiss(animated: true)
        }
    }
    
    func lendCheck(documentID:String){
        db.collection("Book").document(documentID).getDocument { DocumentSnapshot, Error in
            if let Error = Error {
                print(Error)
            }else{
                let data = DocumentSnapshot?.data()
                let lend = data?["lend"] as? String
                print(String(lend!))
                if String(lend!) != ""{
                    self.LendButton.setTitle("貸出中です", for: .normal)
                    self.lendCheckBool = true
                }
            }
        }
    }
    
    func getDocument(){
        db.collection("Book").whereField("title", isEqualTo: BookTitleText).getDocuments { QuerySnapshot, Error in
            for document in QuerySnapshot!.documents{
                if let Error = Error {
                    print(Error)
                }
                self.documentID = document.documentID
                self.setBook(documentID: document.documentID)
                self.lendCheck(documentID: document.documentID)
            }
        }
        
    }
    
    func setBook(documentID:String){
        db.collection("Book").document(documentID).getDocument { DocumentSnapshot, Error in
            if let data = DocumentSnapshot?.data(){
                self.BookTitle.text = data["title"] as? String
                self.AuthorName.text = data["author"] as? String
                self.GenreText.text = data["genre"] as? String
                self.overviewText.text = data["overview"] as? String
            }
        }
        
        let gsReference = storage.reference(withPath: "gs://[BookApp].appspot.com/test/\(documentID).png")
        gsReference.getData(maxSize:  1 * 1024 * 1024) { Data, Error in
            if let Error = Error {
                print(Error)
            }else{
                self.BookImage.image = UIImage(data: Data!)
            }
        }
    }
    
    func setName(){
        db.collection("Book").document(documentID).updateData([
            "lend" :uid ?? "No ID",
            "lendDate" :Timestamp(date: Date())
            ])
    }
    


}
