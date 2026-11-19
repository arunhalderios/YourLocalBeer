//
//  BeerStyleTableViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 06/02/19.
//  Copyright © 2019 Abhishek Mullick. All rights reserved.
//

import UIKit

class BeerStyleTableViewCell: UITableViewCell {

    @IBOutlet weak var lblText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
