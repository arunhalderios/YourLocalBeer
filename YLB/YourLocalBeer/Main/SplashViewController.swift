//
//  SplashViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 23/05/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import CoreLocation


class SplashViewController: UIViewController {

    @IBOutlet weak var launchImage: UIImageView!
    var timer = Timer()
    var window: UIWindow?
    @IBOutlet var loaderImage: UIImageView!
    
    
    //MARK:- View Lifecycle
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        loaderImage.image = UIImage.gif(asset: "Loader_04")
        
        //loaderImage.loadGif(name: "Loader_05")
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 7.0, target: self, selector: #selector(self.goToMainScreen), userInfo: nil, repeats: true)
    }
    
    //MARK:- Navigation method
    @objc func goToMainScreen() {
     
        timer.invalidate()
    
            if CLLocationManager.locationServicesEnabled(){
                print(CLLocationManager.authorizationStatus() )
                switch CLLocationManager.authorizationStatus() {                
                case .notDetermined, .restricted, .denied:
                    self .performSegue(withIdentifier: "segueToLocation", sender: self)
                case  .authorizedAlways, .authorizedWhenInUse:
                    if UserDefaults.standard.bool(forKey: "login")
                    {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Application", bundle:nil)
                        let HomeViewController = storyBoard.instantiateViewController(withIdentifier: "Category") as! CategoryViewController
                        self.navigationController?.pushViewController(HomeViewController, animated: true)
                    }else{
                        self .performSegue(withIdentifier: "segueToMenu", sender: self)
                    }
                @unknown default:
                     let LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Location") as! LocationViewController
                    self.navigationController?.pushViewController(LoginViewController, animated: true)
                }
            }else{
                let LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Location") as! LocationViewController
                self.navigationController?.pushViewController(LoginViewController, animated: true)
                
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImage {
  public class func gif(asset: String) -> UIImage? {
    if let asset = NSDataAsset(name: asset) {
       return UIImage.gif(data: asset.data)
    }
    return nil
  }
}
