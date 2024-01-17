//
//  ResultBookTableViewCell.swift
//  ISC BOOK
//
//  Created by Gomi Kouki on 2023/11/24.
//

import UIKit

class ResultBookTableViewCell: UITableViewCell{

    
    
    
    @IBOutlet weak var BookImage: UIImageView!
    @IBOutlet weak var BookTitle: UILabel!
    @IBOutlet weak var AuthorText: UILabel!
    @IBOutlet weak var GenreText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
