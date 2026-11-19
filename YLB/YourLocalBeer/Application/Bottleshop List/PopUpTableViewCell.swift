//
//  PopUpTableViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 08/11/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import HCSStarRatingView

protocol PopUpTableViewCellDelegate: class {
    
    func PopUpTableViewCell(_ obj: PopUpTableViewCell, like index: Int, section:Int)
    func PopUpTableViewCell(_ obj: PopUpTableViewCell, comment index: Int, section:Int)
    func PopUpTableViewCell(_ obj: PopUpTableViewCell, delete index: Int, section:Int)
}

class PopUpTableViewCell: UITableViewCell {

    
    //MARK: - Custom Delegate Method Initialisation
    var delegate: PopUpTableViewCellDelegate?
    var index: Int?
    var section: Int?
    
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblAmbience: UILabel!
    @IBOutlet weak var lblQuality: UILabel!
    @IBOutlet weak var lblSelection: UILabel!
    @IBOutlet weak var lblStaff: UILabel!
    @IBOutlet weak var lblFood: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnDeleteOutlet: UIButton!
    @IBOutlet weak var btnCommentOutlet: UIButton!
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var lblStaticFoodText: UILabel!
    @IBOutlet weak var lblStaticStaffText: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblAmbience.layer.cornerRadius = 5.0
        self.lblAmbience.layer.masksToBounds = true
        
        self.lblQuality.layer.cornerRadius = 5.0
        self.lblQuality.layer.masksToBounds = true
        
        self.lblSelection.layer.cornerRadius = 5.0
        self.lblSelection.layer.masksToBounds = true
        
        self.lblStaff.layer.cornerRadius = 5.0
        self.lblStaff.layer.masksToBounds = true
        
        self.lblFood.layer.cornerRadius = 5.0
        self.lblFood.layer.masksToBounds = true
        
        self.lblValue.layer.cornerRadius = 5.0
        self.lblValue.layer.masksToBounds = true
        
        self.imgUser.layer.cornerRadius = 20.0
        self.imgUser.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnLikeDidTap(_ sender: Any) {
        delegate?.PopUpTableViewCell((self as PopUpTableViewCell), like: index!, section: section!)
    }
    
    @IBAction func btnCommentsDidTap(_ sender: Any) {
        delegate?.PopUpTableViewCell((self as PopUpTableViewCell), comment: index!, section: section!)
    }
    
    @IBAction func btnDeleteDidTap(_ sender: Any) {
        delegate?.PopUpTableViewCell((self as PopUpTableViewCell), delete: index!, section: section!)
    }
    
}
