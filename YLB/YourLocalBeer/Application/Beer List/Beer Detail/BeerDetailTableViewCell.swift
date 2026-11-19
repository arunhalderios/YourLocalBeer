//
//  BeerDetailTableViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 01/10/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit

protocol BeerDetailTableViewCellDelegate: class {
    
    func BeerDetailTableViewCell(_ obj: BeerDetailTableViewCell, like index: Int, section:Int)
    func BeerDetailTableViewCell(_ obj: BeerDetailTableViewCell, comment index: Int, section:Int)
    func BeerDetailTableViewCell(_ obj: BeerDetailTableViewCell, delete index: Int, section:Int)
}


class BeerDetailTableViewCell: UITableViewCell {

    //MARK: - Custom Delegate Method Initialisation
    var delegate: BeerDetailTableViewCellDelegate?
    var index: Int?
    var section: Int?
    
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblAppearance: UILabel!
    @IBOutlet weak var lblAroma: UILabel!
    @IBOutlet weak var lblMouthfeel: UILabel!
    @IBOutlet weak var lblTaste: UILabel!
    @IBOutlet weak var lblDrinkability: UILabel!
    @IBOutlet weak var lblOverall: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnDeleteOutlet: UIButton!
    @IBOutlet weak var btnCommentOutlet: UIButton!
    @IBOutlet weak var imgLike: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblAppearance.layer.cornerRadius = 5.0
        self.lblAppearance.layer.masksToBounds = true
        
        self.lblAroma.layer.cornerRadius = 5.0
        self.lblAroma.layer.masksToBounds = true
        
        self.lblMouthfeel.layer.cornerRadius = 5.0
        self.lblMouthfeel.layer.masksToBounds = true
        
        self.lblTaste.layer.cornerRadius = 5.0
        self.lblTaste.layer.masksToBounds = true
        
        self.lblDrinkability.layer.cornerRadius = 5.0
        self.lblDrinkability.layer.masksToBounds = true
        
        self.lblOverall.layer.cornerRadius = 5.0
        self.lblOverall.layer.masksToBounds = true
        
        self.imgUser.layer.cornerRadius = 20.0
        self.imgUser.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnLikeDidTap(_ sender: Any) {
        delegate?.BeerDetailTableViewCell((self as BeerDetailTableViewCell), like: index!, section: section!)
    }
    
    @IBAction func btnCommentsDidTap(_ sender: Any) {
        delegate?.BeerDetailTableViewCell((self as BeerDetailTableViewCell), comment: index!, section: section!)
    }
    
    @IBAction func btnDeleteDidTap(_ sender: Any) {
        delegate?.BeerDetailTableViewCell((self as BeerDetailTableViewCell), delete: index!, section: section!)
    }
    

}
