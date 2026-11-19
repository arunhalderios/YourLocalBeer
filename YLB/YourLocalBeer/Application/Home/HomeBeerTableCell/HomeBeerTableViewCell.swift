//
//  HomeBeerTableViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 10/10/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import HCSStarRatingView


protocol HomeBeerTableViewCellDelegate: class {
    
    func HomeBeerTableViewCell(_ obj: HomeBeerTableViewCell, info index: Int)
    func HomeBeerTableViewCell(_ obj: HomeBeerTableViewCell, rate index: Int)
}

class HomeBeerTableViewCell: UITableViewCell {

    //MARK: - Custom Delegate Method Initialisation
    var delegate: HomeBeerTableViewCellDelegate?
    var index: Int?
    
    //MARK: - Variable Declaration
    
    @IBOutlet weak var beerName: UILabel!
    @IBOutlet weak var beerType: UILabel!
    @IBOutlet weak var beerStyle: UILabel!
    @IBOutlet weak var vwCategory: UIView!
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var btnRateOutlet: UIButton!
    @IBOutlet weak var viewRating: HCSStarRatingView!
    @IBOutlet weak var lblNoScore: UILabel!
    @IBOutlet var lblCount: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblCount.layer.cornerRadius = self.lblCount.frame.size.width/2
        lblCount.clipsToBounds = true
        
        btnRateOutlet.layer.cornerRadius = 5
        lblRating.layer.cornerRadius = 5
        lblRating.clipsToBounds = true
        
        vwContent.layer.cornerRadius = 5
        vwContent.clipsToBounds = true
        
        lblNoScore.layer.cornerRadius = 5
        lblNoScore.clipsToBounds = true
        
        
        vwContent.addBorder(toSide: .Left, withColor: UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0).cgColor, andThickness: 4.0)
        
        vwCategory.layer.borderWidth = 2
        vwCategory.layer.borderColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0).cgColor
        vwCategory.layer.cornerRadius = vwCategory.frame.size.width/2
        vwCategory.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnBeerDetailDidTap(_ sender: Any) {
        delegate?.HomeBeerTableViewCell((self as HomeBeerTableViewCell), info: index!)
    }
    
    @IBAction func btnRateItDidTap(_ sender: Any) {
        delegate?.HomeBeerTableViewCell((self as HomeBeerTableViewCell), rate: index!)
    }
    
}
