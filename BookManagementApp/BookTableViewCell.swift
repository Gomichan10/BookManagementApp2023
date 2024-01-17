//
//  BookTableViewCell.swift
//  BookManagementApp
//
//  Created by Gomi Kouki on 2023/11/01.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var BookImage1: UIImageView!
    @IBOutlet weak var BookImage2: UIImageView!
    @IBOutlet weak var BookImage3: UIImageView!
    
    @IBOutlet weak var BookTitle1: UILabel!
    @IBOutlet weak var BookTitle2: UILabel!
    @IBOutlet weak var BookTitle3: UILabel!
    
    @IBOutlet weak var BookGenre1: UILabel!
    @IBOutlet weak var BookGenre2: UILabel!
    @IBOutlet weak var BookGenre3: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
