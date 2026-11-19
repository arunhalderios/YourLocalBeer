//
//  PhotoListCollectionViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 13/07/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit

protocol PhotoListCollectionViewCellDelegate: class {
    
    func PhotoListCollectionViewCell(_ obj: PhotoListCollectionViewCell, more index: Int)
}

class PhotoListCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Custom Delegate Method Initialisation
    var delegate: PhotoListCollectionViewCellDelegate?
    var index: Int?
    
    //MARK: - Variable Declaration
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    
    @IBAction func btnViewMoreDidTap(_ sender: Any) {
        delegate?.PhotoListCollectionViewCell((self as PhotoListCollectionViewCell), more: index!)
    }
    
    
    
}
