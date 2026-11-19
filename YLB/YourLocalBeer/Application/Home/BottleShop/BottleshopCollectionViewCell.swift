//
//  BottleshopCollectionViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 14/06/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit

protocol BottleshopCollectionViewCellDelegate: class {
    
    func BottleshopCollectionViewCell(_ obj: BottleshopCollectionViewCell, info index: Int)
}

class BottleshopCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Custom Delegate Method Initialisation
    var delegate: BottleshopCollectionViewCellDelegate?
    var index: Int?
    
    //MARK: - Variable Declaration
    
    @IBOutlet weak var lblBottleName: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblCount.layer.cornerRadius = self.lblCount.frame.size.width/2
        lblCount.layer.masksToBounds = true
    }
    
    @IBAction func btnBottleCellDidTap(_ sender: Any) {
        delegate?.BottleshopCollectionViewCell((self as BottleshopCollectionViewCell), info: index!)
    }
}
