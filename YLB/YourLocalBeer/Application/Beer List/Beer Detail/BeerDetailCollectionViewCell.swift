//
//  BeerDetailCollectionViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 18/06/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit

protocol BeerDetailCollectionViewCellDelegate: class {
    
    func BeerDetailCollectionViewCell(_ obj: BeerDetailCollectionViewCell, camera index: Int)
    func BeerDetailCollectionViewCell(_ obj: BeerDetailCollectionViewCell, delete index: Int)
}

class BeerDetailCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Custom Delegate Method Initialisation
    var delegate: BeerDetailCollectionViewCellDelegate?
    var index: Int?
    
    @IBOutlet weak var beerImgView: UIImageView!
    @IBOutlet weak var btnCameraOutlet: UIButton!
    @IBOutlet var btnDeleteOutlet: UIButton!
    
    @IBAction func btnCameraDidTap(_ sender: Any) {
        delegate?.BeerDetailCollectionViewCell((self as BeerDetailCollectionViewCell), camera: index!)
    }
    
    @IBAction func btnDeleteDidTap(_ sender: Any) {
        delegate?.BeerDetailCollectionViewCell((self as BeerDetailCollectionViewCell), delete: index!)
    }
}
