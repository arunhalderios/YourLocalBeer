//
//  BeerCollectionViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 13/06/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit

protocol BeerCollectionViewCellDelegate: class {
    
    func BeerCollectionViewCell(_ obj: BeerCollectionViewCell, info index: Int)
}

class BeerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Custom Delegate Method Initialisation
    var delegate: BeerCollectionViewCellDelegate?
    var index: Int?
    
    //MARK: - Variable Declaration
    
    @IBOutlet weak var lblBeerName: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblCount.layer.cornerRadius = self.lblCount.frame.size.width/2
        lblCount.layer.masksToBounds = true
    }
    
    
    @IBAction func btnBeerCellDidTap(_ sender: Any) {
        delegate?.BeerCollectionViewCell((self as BeerCollectionViewCell), info: index!)
    }
}
