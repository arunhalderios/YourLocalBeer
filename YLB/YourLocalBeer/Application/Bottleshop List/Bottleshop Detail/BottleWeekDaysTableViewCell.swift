//
//  BottleWeekDaysTableViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 01/02/19.
//  Copyright © 2019 Abhishek Mullick. All rights reserved.
//

import UIKit

class BottleWeekDaysTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDaysName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
