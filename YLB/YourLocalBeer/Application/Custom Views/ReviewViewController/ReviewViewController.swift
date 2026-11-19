//
//  ReviewViewController.swift
//  YourLocalBeer
//
//  Created by Abhishek Mullick on 26/11/19.
//  Copyright © 2019 Abhishek Mullick. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ReviewViewController: UIViewController {

    @IBOutlet var lblReviewText: UILabel!
    @IBOutlet weak var txtComment: UITextView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if #available(iOS 13.0, *) {
                   overrideUserInterfaceStyle = .light
             } else {
                   // Fallback on earlier versions
            }
           
           txtComment.toolbarPlaceholder = "Write a review"
           txtComment.layer.borderColor = UIColor.lightGray.cgColor
           txtComment.layer.borderWidth = 1.0
           txtComment.layer.cornerRadius = 5
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }

    @objc func endEditing() {
       view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ReviewViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}
