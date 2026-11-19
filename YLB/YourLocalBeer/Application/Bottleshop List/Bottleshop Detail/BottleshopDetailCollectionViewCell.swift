//
//  BottleshopDetailCollectionViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 19/06/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit

protocol BottleshopDetailCollectionViewCellDelegate: class {
    
     func BottleshopDetailCollectionViewCell(_ obj: BottleshopDetailCollectionViewCell, camera index: Int)
    
     func BottleshopDetailCollectionViewCell(_ obj: BottleshopDetailCollectionViewCell, delete index: Int)
}

class BottleshopDetailCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Custom Delegate Method Initialisation
    var delegate: BottleshopDetailCollectionViewCellDelegate?
    var index: Int?
    
    
    @IBOutlet weak var imgBottle: UIImageView!
    @IBOutlet weak var btnCameraOutlet: UIButton!
    @IBOutlet var btnImgDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnImgDelete.layer.cornerRadius = 3
        
    }
    
    @IBAction func btnCameraDidTap(_ sender: Any) {
        delegate?.BottleshopDetailCollectionViewCell((self as BottleshopDetailCollectionViewCell), camera: index!)
    }
    
    @IBAction func btnDeleteDidTap(_ sender: Any) {
        delegate?.BottleshopDetailCollectionViewCell((self as BottleshopDetailCollectionViewCell), delete: index!)
    }    
    
}
