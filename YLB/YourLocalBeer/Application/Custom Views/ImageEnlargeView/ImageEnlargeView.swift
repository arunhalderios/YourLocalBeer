//
//  ImageEnlargeView.swift
//  YourLocalBeer
//
//  Created by Abhishek Mullick on 29/11/19.
//  Copyright © 2019 Abhishek Mullick. All rights reserved.
//

import UIKit

class ImageEnlargeView: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet var imgEnlargeView: UIImageView!
    
    var panRecognizer: UIPanGestureRecognizer?
    var pinchRecognizer: UIPinchGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        self.pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch(recognizer:)))
        //delegate gesture with UIGestureRecognizerDelegate
        pinchRecognizer?.delegate = self
        panRecognizer?.delegate = self

        self.imgEnlargeView.addGestureRecognizer(panRecognizer!)
        self.imgEnlargeView.addGestureRecognizer(pinchRecognizer!)
        
        // Do any additional setup after loading the view.
    }
    
    // handle UIPanGestureRecognizer
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
         let gview = recognizer.view
         if recognizer.state == .began || recognizer.state == .changed {
              let translation = recognizer.translation(in: gview?.superview)
              gview?.center = CGPoint(x: (gview?.center.x)! + translation.x, y: (gview?.center.y)! + translation.y)
              recognizer.setTranslation(CGPoint.zero, in: gview?.superview)
         }
    }

    // handle UIPinchGestureRecognizer
    @objc func handlePinch(recognizer: UIPinchGestureRecognizer) {
         if recognizer.state == .began || recognizer.state == .changed {
              recognizer.view?.transform = (recognizer.view?.transform.scaledBy(x: recognizer.scale, y: recognizer.scale))!
              recognizer.scale = 1.0
        }
    }
    
    // mark sure you override this function to make gestures work together
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
