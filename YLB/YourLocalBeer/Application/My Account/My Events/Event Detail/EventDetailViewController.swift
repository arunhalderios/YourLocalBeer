//
//  EventDetailViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 18/07/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import MapKit

class EventDetailViewController: UIViewController {

    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblEventDate: UILabel!
    @IBOutlet weak var lblEventAddress: UILabel!
    @IBOutlet weak var lblEventDescription: UILabel!
    @IBOutlet weak var eventLocationMapView: MKMapView!
    var eventData = NSDictionary()
    var accudate1 = String()
    var accudate2 = String()
    var lat = Double()
    var lng = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        lblEventName.numberOfLines = 0
        lblEventName.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        lblEventDate.numberOfLines = 0
        lblEventDate.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        lblEventAddress.numberOfLines = 0
        lblEventAddress.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        lblEventDescription.numberOfLines = 0
        lblEventDescription.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        print(eventData)
        
        self.lblEventName.text = eventData["event_title"] as? String
        self.lblEventAddress.text = eventData["event_location"] as? String
        self.lblEventDescription.text = eventData["event_content"] as? String
        let string1 = "\(eventData["event_start_date"]!)"
        let string2 = "\(eventData["event_end_date"]!)"
        
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "E MMM-d-yyyy h:mm a"
        
        if let date = dateFormatterGet.date(from: string1) {
            print(dateFormatterPrint.string(from: date))
            accudate1 = dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string")
        }
        
        if let date2 = dateFormatterGet.date(from: string2) {
            print(dateFormatterPrint.string(from: date2))
            accudate2 = dateFormatterPrint.string(from: date2)
        } else {
            print("There was an error decoding the string")
        }
        
        self.lblEventDate.text = "\(accudate1) - \(accudate2)"
        lat = Double(eventData["lat"] as! String)!
        lng = Double(eventData["lng"] as! String)!
        
        let latDelta:CLLocationDegrees = 0.01
        
        let longDelta:CLLocationDegrees = 0.01
        
        let theSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let pointLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lng)
        
        let region:MKCoordinateRegion = MKCoordinateRegion(center: pointLocation, span: theSpan)
        eventLocationMapView.setRegion(region, animated: true)
        
        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lng)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = eventData["event_title"] as? String
        self.eventLocationMapView.addAnnotation(objectAnnotation)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnEditEventDidTap(_ sender: Any) {
        
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
