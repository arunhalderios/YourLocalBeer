//
//  BreweryDetailCollectionViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 18/06/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit


protocol BreweryDetailCollectionViewCellDelegate: class {
    
    func BreweryDetailCollectionViewCell(_ obj: BreweryDetailCollectionViewCell, camera index: Int)
    
    func BreweryDetailCollectionViewCell(_ obj: BreweryDetailCollectionViewCell, delete index: Int)
    
}

class BreweryDetailCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Custom Delegate Method Initialisation
    var delegate: BreweryDetailCollectionViewCellDelegate?
    var index: Int?
    
    @IBOutlet weak var imgBrewery: UIImageView!
    @IBOutlet weak var btnCameraOutlet: UIButton!
    @IBOutlet var btnDeleteOutlet: UIButton!
    
    
    @IBAction func btnCameraDidTap(_ sender: Any) {
        delegate?.BreweryDetailCollectionViewCell((self as BreweryDetailCollectionViewCell), camera: index!)
    }
    
    @IBAction func btnDeleteDidTap(_ sender: Any) {
        delegate?.BreweryDetailCollectionViewCell((self as BreweryDetailCollectionViewCell), delete: index!)
    }
    
}
