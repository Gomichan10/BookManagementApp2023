//
//  BookLentViewController.swift
//  BookManagementApp
//
//  Created by Gomi Kouki on 2023/11/14.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class BookLentViewController: UIViewController {
    
    @IBOutlet weak var BookName: UILabel!
    @IBOutlet weak var BookTitle: UILabel!
    @IBOutlet weak var AuthorName: UILabel!
    @IBOutlet weak var overviewText: UILabel!
    @IBOutlet weak var GenreText: UILabel!
    @IBOutlet weak var BookImage: UIImageView!
    @IBOutlet weak var LendButton: UIButton!
    @IBOutlet weak var ReturnDate: UILabel!
    
    let uid = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var reference:StorageReference

    
    var documentID = ""
    var BookTitleText = ""
    
    required init?(coder aDecoder: NSCoder) {
        self.reference = self.storage.reference()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDocument()
    }
    

    func setName(){
        db.collection("Book").document(documentID).updateData([
            "lent":FieldValue.arrayUnion([uid!]),
            "lend":""
            ])
    }
    
    func getDocument(){
        db.collection("Book").whereField("title", isEqualTo: BookTitleText).getDocuments { QuerySnapshot, Error in
            for document in QuerySnapshot!.documents{
                self.documentID = document.documentID
                self.setBook(documentID: document.documentID)
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
                let lendDate = data["lendDate"] as! Timestamp
                self.ReturnDate.text = "返却期限：\(self.addingDate(date: lendDate.dateValue()))まで"
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
    
    func addingDate(date:Date) -> String{
        let addingdate = Calendar.current.date(byAdding: .month, value: 1, to: date)!
        let df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.dateStyle = .long
        df.timeStyle = .none
        return df.string(from: addingdate)
    }
    
    @IBAction func LentButton(_ sender: Any) {
        setName()
        dismiss(animated: true)
    }
    
    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
