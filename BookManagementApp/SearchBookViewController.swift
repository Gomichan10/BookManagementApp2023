//
//  SearchBookViewController.swift
//  BookManagementApp
//
//  Created by Gomi Kouki on 2023/11/19.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class SearchBookViewController: UIViewController,UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var infrastructureImage: UIImageView!
    @IBOutlet weak var iotImage: UIImageView!
    @IBOutlet weak var webImage: UIImageView!
    @IBOutlet weak var aiImage: UIImageView!
    @IBOutlet weak var mobileImage: UIImageView!
    @IBOutlet weak var qualificationImage: UIImageView!
    @IBOutlet weak var barcodeImage: UIImageView!
    
    let db = Firestore.firestore()
    var documents:[DocumentSnapshot] = []
    var SearchGenre = ""
    var bookNames = [""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.tintColor = UIColor.black
    
        let tapInfrastructure = UITapGestureRecognizer(target: self, action: #selector(InfrastructureTapped))
        infrastructureImage.addGestureRecognizer(tapInfrastructure)
        infrastructureImage.isUserInteractionEnabled = true
        
        let tapIot = UITapGestureRecognizer(target: self, action: #selector(IotTapped))
        iotImage.addGestureRecognizer(tapIot)
        iotImage.isUserInteractionEnabled = true
        
        let tapWeb = UITapGestureRecognizer(target: self, action: #selector(WebTapped))
        webImage.addGestureRecognizer(tapWeb)
        webImage.isUserInteractionEnabled = true
        
        let tapAI = UITapGestureRecognizer(target: self, action: #selector(AITapped))
        aiImage.addGestureRecognizer(tapAI)
        aiImage.isUserInteractionEnabled = true
        
        let tapMobile = UITapGestureRecognizer(target: self, action: #selector(MobileTapped))
        mobileImage.addGestureRecognizer(tapMobile)
        mobileImage.isUserInteractionEnabled = true
        
        let tapQualification = UITapGestureRecognizer(target: self, action: #selector(QualificationTapped))
        qualificationImage.addGestureRecognizer(tapQualification)
        qualificationImage.isUserInteractionEnabled = true
        
        let tapBarcode = UITapGestureRecognizer(target: self, action: #selector(BarcodeTappend))
        barcodeImage.addGestureRecognizer(tapBarcode)
        barcodeImage.isUserInteractionEnabled = true

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func InfrastructureTapped(){
        
        self.SearchGenre = "インフラ"
        performSegue(withIdentifier: "SearchResult", sender: nil)
        
    }
    
    @objc func IotTapped(){
        
        self.SearchGenre = "IoT"
        performSegue(withIdentifier: "SearchResult", sender: nil)
        
    }
    
    @objc func WebTapped(){
        
        self.SearchGenre = "Web"
        performSegue(withIdentifier: "SearchResult", sender: nil)
        
    }
    
    @objc func AITapped(){
        
        self.SearchGenre = "Web"
        performSegue(withIdentifier: "SearchResult", sender: nil)
        
    }
    
    @objc func MobileTapped(){
        
        self.SearchGenre = "Web"
        performSegue(withIdentifier: "SearchResult", sender: nil)
        
    }
    
    
    @objc func QualificationTapped(){
        self.SearchGenre = "資格"
        performSegue(withIdentifier: "SearchResult", sender: nil)
        
    }
    
    @objc func BarcodeTappend(){
        performSegue(withIdentifier: "barcode", sender: nil)
    }
    
    func getDB(){
        self.bookNames = [""]
        db.collection("Book").getDocuments { QuerySnapshot, Error in
            if let Error = Error {
                print(Error)
                return
            }
            for data in QuerySnapshot!.documents {
                var bookName = data["title"] as! String
                self.searchBookTitle(bookName: bookName)
            }
            self.performSegue(withIdentifier: "SearchResult", sender: nil)
        }
    }
    
    func searchBookTitle(bookName: String){
        var flg: Bool = bookName.contains(String(searchBar.text!))
        if flg == true {
            bookNames.append(bookName)
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        SearchGenre = ""
        getDB()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    @IBAction func SearchButton(_ sender: Any) {
        getDB()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchResult" {
            let VC = segue.destination as? SearchResultViewController
            if SearchGenre != "" {
                VC?.SearchGenre = self.SearchGenre
            }else{
                VC?.SearchTitle = bookNames
            }
            
        }
    }
    
}


