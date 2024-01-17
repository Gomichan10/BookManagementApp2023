//
//  SearchResultViewController.swift
//  ISC BOOK
//
//  Created by Gomi Kouki on 2023/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class SearchResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var ResultBookTable: UITableView!
    @IBOutlet weak var NoBookLabel: UILabel!
    
    
    var documents:[DocumentSnapshot] = []
    var SearchTitle = [""]
    var SearchGenre = ""
    var documentID = ""
    var bookTitle = ""
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var reference:StorageReference
    
    
    required init?(coder aDecoder: NSCoder) {
        self.reference = self.storage.reference()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SearchTitle == [""]{
            getSearchGenreDocuments()
        }else{
            getSearchDocuments()
        }
        
        print(documents)
        print(SearchTitle)
        print(SearchGenre)
        
        ResultBookTable.register(UINib(nibName: "ResultBookTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ResultBookTable.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! ResultBookTableViewCell
        
        
        let data = documents[indexPath.row].data()
        self.documentID = documents[indexPath.row].documentID
        cell.BookTitle.text = data?["title"] as? String
        cell.AuthorText.text = data?["author"] as? String
        cell.GenreText.text = data?["genre"] as? String
        
        let gsReference = storage.reference(withPath: "gs://[BookApp].appspot.com/test/\(documentID).png")
        gsReference.getData(maxSize:  1 * 1024 * 1024) { Data, Error in
            if let Error = Error {
                print(Error)
            }else{
                cell.BookImage.image = UIImage(data: Data!)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedCell = ResultBookTable.cellForRow(at: indexPath) as? ResultBookTableViewCell {
            self.bookTitle = selectedCell.BookTitle.text!
            performSegue(withIdentifier: "bookLend", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookLend" {
            let VC = segue.destination as? BookLendViewController
            VC?.BookTitleText = self.bookTitle
        }
    }
    
    func getSearchDocuments(){
        db.collection("Book")
            .whereField("title",in: SearchTitle).getDocuments { QuerySnapshot, Error in
            if let Error = Error {
                print(Error)
            }else{
                if let documents = QuerySnapshot?.documents{
                    self.documents = documents
                    print(self.documents.count)
                    if documents.count == 0 {
                        self.NoBookLabel.text = "本が見つかりませんでした"
                    }
                    self.ResultBookTable.reloadData()
                }
            }
        }
    }
    
    func getSearchGenreDocuments(){
        db.collection("Book").whereField("genre", isEqualTo: SearchGenre).getDocuments { QuerySnapshot, Error in
            if let Error = Error {
                print(Error)
            }else{
                if let documents = QuerySnapshot?.documents{
                    self.documents = documents
                    if documents.count == 0 {
                        self.NoBookLabel.text = "本が見つかりませんでした"
                    }
                    self.ResultBookTable.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true)
    }

}
