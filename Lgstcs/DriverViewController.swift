//
//  DriverViewController.swift
//  Lgstcs
//
//  Created by Michael Latson on 6/11/15.
//  Copyright (c) 2015 Lgstcs Co. All rights reserved.
//

import UIKit 
import Parse
import MapKit 
import CoreLocation

class DriverViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var manager:CLLocationManager!
    
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
//        manager.delegate = self
        self.loadArr()
        
        //Check if App has authorization to access user location
        
        if CLLocationManager.locationServicesEnabled(){
            switch CLLocationManager.authorizationStatus(){
            case .Denied:
                displayAlertWithTitle("Not Determined",
                    message: "Location services are not allowed for this app")
            case .NotDetermined:
                manager.requestAlwaysAuthorization()
            case .Restricted:
                displayAlertWithTitle("Restricted",
                    message: "Location services are not allowed for this app")
            default:
                println("Default")
            }
            
        } else {
            println("Location services are not enabled")
        }
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
    }
        func loadArr(){
        //Create loads Array using Parse.com
        var loadsArr: Array<Load> = [] {
            didSet {
                
                let vtv:TableMapViewController = TableMapViewController(frame: self.window?.frame as CGRect!)
                vtv.setLoadCollection(loadsArr)
                let nav:UINavigationController = UINavigationController(rootViewController: vtv)
                self.window!.rootViewController =  nav
                self.window!.backgroundColor = UIColor.whiteColor()
                self.window!.makeKeyAndVisible()
                
            }
            
        }
        
        // query should be current location + radius → pickupDate > currentDate → available == true
        var query = PFQuery(className:"load")
        query.whereKey("available", equalTo:true)
        query.includeKey("load")
        query.findObjectsInBackgroundWithBlock( {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                println("Successfully retrieved \(objects!.count) loads.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        //Latitude and Longitude are both Int in Parse. Code should either be changed to defining them as a Int or cast them here as a string. Currently have them as both an Int and String in Parse.
                        
                        let x = Load(aIdent: (object["Ident"] as! Int),aShipperName: (object["shipperName"] as! String), aShipperCompany: (object["shipperCompany"] as! String), aShipperAddress: (object["shipperAddress"] as! String), aShipperCity: (object["shipperCity"] as! String), aShipperState: (object["shipperState"] as! String), aShipperPhone: (object["shipperPhone"] as! String), aShipperEmail: (object["shipperEmail"] as! String), aShipperLat: (object["shipperLat"] as! String), aShipperLng: (object["shipperLng"] as! String), aDeliveryName: (object["deliveryName"] as! String), aDeliveryAddress: (object["deliveryAddress"] as! String), aDeliveryCity: (object["deliveryCity"] as! String), aDeliveryState: (object["deliveryState"] as! String), aDeliveryPhone: (object["deliveryPhone"] as! String), aDeliveryLat: (object["deliveryLat"] as! String), aDeliveryLng: (object["deliveryLng"] as! String), aTypeOfLoad: (object["typeofLoad"] as! String), aWeight: (object["weight"] as! String),  aId: (object["objectID"] as! String))
                        
                        loadsArr.append(x)
                        
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
            }
       )
    
}
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    
    
}
