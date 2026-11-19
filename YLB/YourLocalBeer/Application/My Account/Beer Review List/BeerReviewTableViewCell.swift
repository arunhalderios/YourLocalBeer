//
//  BeerReviewTableViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 13/07/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import HCSStarRatingView

protocol BeerReviewTableViewCellDelegate: class {
    
    func BeerReviewTableViewCell(_ obj: BeerReviewTableViewCell, edit index: Int, section:Int)
    func BeerReviewTableViewCell(_ obj: BeerReviewTableViewCell, details index: Int, section:Int)
    func BeerReviewTableViewCell(_ obj: BeerReviewTableViewCell, delete index: Int, section:Int)
}

class BeerReviewTableViewCell: UITableViewCell {

    //MARK: - Custom Delegate Method Initialisation
    var delegate: BeerReviewTableViewCellDelegate?
    var index: Int?
    var section: Int?
    
    
    //MARK: - Variable Declaration
    
    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var beerName: UILabel!
    @IBOutlet weak var beerAddress: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblStaticRate: UILabel!
    @IBOutlet weak var btnEditOutlet: UIButton!
    @IBOutlet var btnDeleteOutlet: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblRate.layer.cornerRadius = 5.0
        self.lblRate.layer.masksToBounds = true
        
        self.btnEditOutlet.layer.cornerRadius = 5.0
        self.btnEditOutlet.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnEditDidTap(_ sender: Any) {
        delegate?.BeerReviewTableViewCell((self as BeerReviewTableViewCell), edit: index!, section: section!)
    }
    
    @IBAction func btnDetailsDidTap(_ sender: Any) {
         delegate?.BeerReviewTableViewCell((self as BeerReviewTableViewCell), details: index!, section: section!)
    }
    
    @IBAction func btnReviewDeleteDidTap(_ sender: Any) {
        delegate?.BeerReviewTableViewCell((self as BeerReviewTableViewCell), delete: index!, section: section!)
    }
    
}
