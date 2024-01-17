//
//  BookCollectionViewCell.swift
//  BookManagementApp
//
//  Created by Gomi Kouki on 2023/11/01.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    

    
    @IBOutlet weak var BookGenre: UILabel!
    @IBOutlet weak var BookTitle: UILabel!
    @IBOutlet weak var BookImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
