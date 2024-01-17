//
//  GoogleBooksViewController.swift
//  ISC BOOK
//
//  Created by Gomi Kouki on 2023/12/04.
//

import UIKit



class GoogleBooksViewController: UIViewController{

    
    

    
    @IBOutlet weak var searchField: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
    }

    
    @IBAction func searchButton(_ sender: Any) {
        performSegue(withIdentifier: "searchBook", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchBook"{
            let VC = segue.destination as? BookResultViewController
            VC?.searchIsbn = searchField.text!
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
