//
//  TableViewCell.swift
//  YourMemories
//
//  Created by Kursat Coskun on 7.06.2018.
//  Copyright © 2018 Kursat Coskun. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var resimCell: UIImageView!
    
    @IBOutlet weak var yorumCell: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
