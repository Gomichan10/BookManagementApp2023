//
//  GoogleSearchTableViewCell.swift
//  ISC BOOK
//
//  Created by Gomi Kouki on 2023/12/04.
//

import UIKit

class GoogleSearchTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
