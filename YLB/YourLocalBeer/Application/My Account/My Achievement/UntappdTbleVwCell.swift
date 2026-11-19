//
//  UntappdTbleVwCell.swift
//  YourLocalBeer
//
//  Created by Arun Halder on 26/08/20.
//  Copyright © 2020 Abhishek Mullick. All rights reserved.
//

import UIKit

class UntappdTbleVwCell: UITableViewCell {
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var brandLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
