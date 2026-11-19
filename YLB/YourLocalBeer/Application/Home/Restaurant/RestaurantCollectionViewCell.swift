//
//  RestaurantCollectionViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 20/06/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit

protocol RestaurantCollectionViewCellDelegate: class {
    
    func RestaurantCollectionViewCell(_ obj: RestaurantCollectionViewCell, info index: Int)
}

class RestaurantCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Custom Delegate Method Initialisation
    var delegate: RestaurantCollectionViewCellDelegate?
    var index: Int?
    
    //MARK: - Variable Declaration
    
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblCount.layer.cornerRadius = self.lblCount.frame.size.width/2
        lblCount.layer.masksToBounds = true
    }
    
    
    @IBAction func btnBarCellDidTap(_ sender: Any) {
        delegate?.RestaurantCollectionViewCell((self as RestaurantCollectionViewCell), info: index!)
    }
    
}
