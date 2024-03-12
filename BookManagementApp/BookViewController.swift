//
//  BookViewController.swift
//  BookManagementApp
//
//  Created by Gomi Kouki on 2023/11/01.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage



class BookViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate{
    
    

    @IBOutlet weak var BookView: UICollectionView!
    
    @IBOutlet weak var itpasImage: UIImageView!
    @IBOutlet weak var ouyouImage: UIImageView!
    @IBOutlet weak var AWSImage: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let db = Firestore.firestore()
    var documentCount = 0
    var documentID = "0JM8tPv49e8lDqUtZ6tu"
    let storage = Storage.storage()
    var reference:StorageReference
    var documents:[DocumentSnapshot] = []
    var BookTitle = ""
    
    required init?(coder aDecoder: NSCoder) {
        self.reference = self.storage.reference()
        super.init(coder: aDecoder)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDocumentCount()
        getDocuments()
        
        BookView.delegate = self
        BookView.dataSource = self
        BookView.register(UINib(nibName: "BookCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BookCell")
        configureRefleshControl()
        BookView.reloadData()
        
        let tapItpas = UITapGestureRecognizer(target: self, action: #selector(itpasTapped))
        itpasImage.addGestureRecognizer(tapItpas)
        itpasImage.isUserInteractionEnabled = true
        
        let tapOuyou = UITapGestureRecognizer(target: self, action: #selector(ouyouTapped))
        ouyouImage.addGestureRecognizer(tapOuyou)
        ouyouImage.isUserInteractionEnabled = true
        
        let tapAWS = UITapGestureRecognizer(target: self, action: #selector(awsTapped))
        AWSImage.addGestureRecognizer(tapAWS)
        AWSImage.isUserInteractionEnabled = true
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(3), height: scrollView.frame.height)
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.orange
    }
    
    @objc func itpasTapped(){
        
        BookTitle = "ITパスポート"
        performSegue(withIdentifier: "BookLend", sender: nil)
        
    }
    
    @objc func ouyouTapped(){
        
        BookTitle = "応用情報技術者試験"
        performSegue(withIdentifier: "BookLend", sender: nil)
        
    }
    
    @objc func awsTapped(){
        
        BookTitle = "AWS"
        performSegue(withIdentifier: "BookLend", sender: nil)
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {

        print(documentCount)
    }
    
    
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
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedCell = BookView.cellForItem(at: indexPath) as? BookCollectionViewCell{
            self.BookTitle = selectedCell.BookTitle.text!
        }
        performSegue(withIdentifier: "BookLend", sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        pageControl.currentPage = currentPage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BookLend" {
            let VC = segue.destination as? BookLendViewController
            VC?.BookTitleText = self.BookTitle
        }
    }
    
    func getDocuments(){
        db.collection("Book").order(by: "time", descending: false).getDocuments { QuerySnapshot, Error in
            if let Error = Error{
                print(Error)
            }
            if let documets = QuerySnapshot?.documents{
                self.documents = documets
                self.BookView.reloadData()
            }
        }
    }
    
    func getDocumentCount(){
        db.collection("Book").getDocuments { QuerySnapshot, Error in
            if let Error = Error {
                print(Error)
            }
            self.documentCount = (QuerySnapshot?.documents.count)!
        }
    }
    
    func configureRefleshControl(){
        BookView.refreshControl = UIRefreshControl()
        BookView.refreshControl?.addTarget(self, action: #selector(handleRefleshControl), for: .valueChanged)
    }
    
    @objc func handleRefleshControl(){
        getDocumentCount()
        getDocuments()
        BookView.refreshControl?.endRefreshing()
    }
    
    
    

}
