//
//  MenuTableViewCell.swift
//  LeakIt
//
//  Created by Techno-MAC on 07/02/18.
//  Copyright © 2018 Techno-MAC. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var vwImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        vwImage.layer.cornerRadius = vwImage.frame.size.width/2
//        vwImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
