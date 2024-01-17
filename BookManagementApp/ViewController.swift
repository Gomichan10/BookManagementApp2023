//
//  ViewController.swift
//  BookManagementApp
//
//  Created by Gomi Kouki on 2023/11/01.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    
    
    @IBOutlet weak var BookTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "BookTableViewCell", bundle: nil)
        BookTable.register(nib, forCellReuseIdentifier: "BookCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BookTable.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 212.0
    }

}

