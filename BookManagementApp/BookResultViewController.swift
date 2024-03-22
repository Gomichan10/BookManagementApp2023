//
//  BookResultViewController.swift
//  ISC BOOK
//
//  Created by Gomi Kouki on 2023/12/14.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Alamofire
import SwiftyJSON

class BookResultViewController: UIViewController {
    
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookGenre: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookOverview: UILabel!
    
    var book:Book?
    var searchIsbn = ""
    var documentID = ""
    var NowTime = Timestamp(date: Date())
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var reference:StorageReference
    
    required init?(coder aDecoder: NSCoder) {
        self.reference = self.storage.reference()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(searchIsbn)
        searchBooks(isbn: searchIsbn)
        
    }
    
    func searchBooks(isbn:String){
        let apiKey = "AIzaSyDZLzFjafLll2M3FIxTyY814CB5Az9j54s"
        let baseURL = "https://www.googleapis.com/books/v1/volumes"
        let parameters: [String:Any] = [
            "q": "isbn:" + isbn,
            "key": apiKey,
        ]
        
        AF.request(baseURL,method: .get,parameters: parameters).responseJSON{ response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.parseBook(from: json)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    func parseBook(from json:JSON){
        guard let item = json["items"].array?.first else{return}
        
        print(item)
        
        let volumeInfo = item["volumeInfo"]
        let title = volumeInfo["title"].stringValue
        let thumbnailURL = volumeInfo["imageLinks"]["thumbnail"].url
        let publishedDate = volumeInfo["publishedDate"].string
        let categories = volumeInfo["categories"].array?.compactMap{$0.stringValue}
        let authors = volumeInfo["authors"].array?.compactMap{$0.stringValue}
        let description = volumeInfo["description"].string
        
        book = Book(title: title,thumbnailURL: thumbnailURL,publishedDate: publishedDate,categories: categories,authors: authors,desctiption: description)
        
        setBookInfo()
    }
    
    func setBookInfo(){
        guard let book = book else {return}
        
        print(book)
        
        bookTitle.text! = book.title
        bookGenre.text! = book.categories?[0] ?? "No Categories"
        bookAuthor.text! = book.authors?[0] ?? "No Authors"
        bookOverview.text! = book.desctiption ?? "No Desctiption"
        
        if let url = book.thumbnailURL {
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.bookImage.image = image
                        }
                    }
                }catch {
                    print(error)
                }
            }
        }
        
    }
    
    func getDocumentID(){
        db.collection("Book").whereField("title", isEqualTo: bookTitle.text!).getDocuments { QuerySnapshot, Error in
            if let Error = Error {
                print(Error)
            }
            for documtns in QuerySnapshot!.documents{
                self.documentID = documtns.documentID
            }
            self.updataStorage()
        }
    }
    
    func updataStorage(){
        let path = "gs://[BookApp].appspot.com/test/\(documentID).png"
        let ImageRef = self.reference.child(path)
        let image = bookImage.image
        guard let data = image?.pngData() else{
            return
        }
        let upload = ImageRef.putData(data)
    }
    
    @IBAction func addButton(_ sender: Any) {
        db.collection("Book").document().setData(
                    [
                     "title": bookTitle.text!,
                     "genre":bookGenre.text!,
                     "author":bookAuthor.text!,
                     "overview":bookOverview.text!,
                     "time":NowTime,
                     "lend":"",
                     "lent":[""],
                     "isbn":searchIsbn
                    ]
        ){Error in
                    if let Error = Error {
                        print(Error)
                    }else{
                        print("Success")
                    }
        }
        getDocumentID()
        dismiss(animated: true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
