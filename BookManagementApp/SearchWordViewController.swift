//
//  SearchWordViewController.swift
//  ISC BOOK
//
//  Created by Gomi Kouki on 2024/01/11.
//

import UIKit
import FirebaseFirestore

class SearchWordViewController: UIViewController {
    
    let db = Firestore.firestore()
    var bookNames = [""]
    
    
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func searchButton(_ sender: Any) {
        getAllBook()
    }
    
    //登録してあるすべての本の情報を受け取る
    func getAllBook(){
        db.collection("Book").getDocuments { QuerySnapshot, Error in
            if let Error = Error {
                print(Error)
                return
            }
            for document in QuerySnapshot!.documents{
                var Title = document["title"] as! String
                self.searchBookTitle(Title: Title)
            }
        }
        printBookInfo()
    }
    
    //全文検索を行なって検索文字が含まれている本のタイトルを配列に格納する
    func searchBookTitle(Title:String){
        var flg :Bool = Title.contains(textField.text!)
        if flg == true {
            bookNames.append(Title)
        }
    }
    
    //本の情報を出力する
    func printBookInfo(){
        db.collection("Book").whereField("title", in: bookNames).getDocuments { QuerySnapshot, Error in
            if let Error = Error {
                print(Error)
                return
            }
            for data in QuerySnapshot!.documents {
                var title = data["title"] as! String
                var author  = data["author"] as! String
                print(title)
                print(author)
            }
        }
    }
    
}
