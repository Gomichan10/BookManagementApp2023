//
//  BookAddViewController.swift
//  BookManagementApp
//
//  Created by Gomi Kouki on 2023/11/02.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage


class BookAddViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    
    @IBOutlet weak var BookTitleField: UITextField!
    @IBOutlet weak var BookGenreField: UITextField!
    @IBOutlet weak var BookAuthorField: UITextField!
    @IBOutlet weak var BookImage: UIImageView!
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var reference:StorageReference
    var Genres:[String] = []
    var documentID = ""
    let NowTime = Timestamp(date: Date())
    var dataToUpdate: Bool = false
    weak var pickerView:UIPickerView?
    
    
    required init?(coder aDecoder: NSCoder) {
        self.reference = self.storage.reference()
        super.init(coder: aDecoder)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Genres.append("")
        Genres.append("IoT")
        Genres.append("インフラ")
        Genres.append("機械学習")
        Genres.append("Web")
        Genres.append("モバイル")
        Genres.append("資格")
        
        let pv = UIPickerView()
        pv.delegate = self
        pv.dataSource = self
        
        BookGenreField.delegate = self
        BookGenreField.inputAssistantItem.leadingBarButtonGroups = []
        BookGenreField.inputView = pv
        self.pickerView = pv
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        BookImage.isUserInteractionEnabled = true
        BookImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func tapped(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Genres.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Genres[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        BookGenreField.text = Genres[row]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            BookImage.image = selectedImage
        }
        self.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    
    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func BookAddButton(_ sender: Any) {
        
        db.collection("Book").document().setData(
                    [
                     "title": BookTitleField.text!,
                     "genre":BookGenreField.text!,
                     "author":BookAuthorField.text!,
                     "time":NowTime,
                     "lend":"",
                     "lent":[""]
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
    
    func getDocumentID(){
        db.collection("Book").whereField("title", isEqualTo: BookTitleField.text!).getDocuments { QuerySnapshot, Error in
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
        let image = BookImage.image
        guard let data = image?.pngData() else{
            return
        }
        let upload = ImageRef.putData(data)
    }
}
