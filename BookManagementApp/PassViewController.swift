//
//  PassViewController.swift
//  ISC BOOK
//
//  Created by Gomi Kouki on 2023/12/14.
//

import UIKit
import FirebaseFirestore

class PassViewController: UIViewController {
    
    var password = ""
    let db = Firestore.firestore()

    @IBOutlet weak var passField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setPassword()
        
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        if password == passField.text!{
            performSegue(withIdentifier: "BookAdd", sender: nil)
        }else{
            let alert = UIAlertController(title: "パスワードが正しくありません",message: "入力されたパスワードが間違っています。確認の上、もう一度お試しください。", preferredStyle: .alert)
            let ok = UIAlertAction(title: "了解", style: .default)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func setPassword(){
        db.collection("Password").document("BookPassword1214").getDocument { DocumentSnapshot, Error in
            if let Error = Error {
                print(Error)
                return
            }
            if let data = DocumentSnapshot?.data(){
                self.password = data["password"] as! String
            }
            print(self.password)
        }
    }

}
