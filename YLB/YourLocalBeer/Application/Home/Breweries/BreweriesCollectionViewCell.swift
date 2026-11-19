//
//  BreweriesCollectionViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 13/06/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit

protocol BreweriesCollectionViewCellDelegate: class {
    
    func BreweriesCollectionViewCell(_ obj: BreweriesCollectionViewCell, info index: Int)
}

class BreweriesCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Custom Delegate Method Initialisation
    var delegate: BreweriesCollectionViewCellDelegate?
    var index: Int?
    
    //MARK: - Variable Declaration
    
    @IBOutlet weak var lblBreweryName: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblCount.layer.cornerRadius = self.lblCount.frame.size.width/2
        lblCount.layer.masksToBounds = true
    }
    
    
    
    
    @IBAction func btnBreweryCellDidTap(_ sender: Any) {
        delegate?.BreweriesCollectionViewCell((self as BreweriesCollectionViewCell), info: index!)
    }
}
