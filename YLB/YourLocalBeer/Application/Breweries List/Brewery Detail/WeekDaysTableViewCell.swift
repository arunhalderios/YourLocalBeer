//
//  WeekDaysTableViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 30/01/19.
//  Copyright © 2019 Abhishek Mullick. All rights reserved.
//

import UIKit

class WeekDaysTableViewCell: UITableViewCell {

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
