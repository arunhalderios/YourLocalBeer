//
//  AchievementCollectionViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 17/07/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit

class AchievementCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblAchieveCount: UILabel!
    @IBOutlet weak var lblAchievementName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblAchieveCount.layer.borderWidth = 1
        self.lblAchieveCount.layer.borderColor = UIColor.red.cgColor
        self.lblAchieveCount.layer.cornerRadius = self.lblAchieveCount.frame.size.width/2
//        self.lblAchieveCount.layer.masksToBounds = true
        
        self.lblAchievementName.numberOfLines = 0
        self.lblAchievementName.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.lblAchievementName.layer.masksToBounds = true
    }
    
    
}
