//
//  LoadDetailViewController.swift
//  Lgstcs
//
//  Created by Michael Latson on 6/11/15.
//  Copyright (c) 2015 Lgstcs Co. All rights reserved.
//

import UIKit
import MapKit
import Parse

class LoadDetailViewController: UIViewController {

    var lblPickup:UILabel?
    var lblDelivery: UILabel?
    var lblTypeOfLoad: UILabel?
    var lblWeight: UILabel?
    //Put miles into the array and in the backend
    var lblMiles: UILabel?
    //Put Price per mile into the array and in the backend
    var lblPricePerMile: UILabel?
    //Put Notes into the array
    var lblNotes: UILabel?
    var id = ""
    let button = UIButton.buttonWithType(UIButtonType.System) as! UIButton
    var manager: CLLocationManager!
    var alat = ""
    var alng = ""
    var blat = ""
    var blng = ""
    var pickupAddressFull = ""
    var phoneNumber = ""
    var contactName = ""
    var deliveryAddressFull = ""
    
    
    var navHeight:CGFloat?
    var width:CGFloat?
    var halfHeight:CGFloat?
    var height:CGFloat?
    
   
    convenience init(){ 
        self.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        
        navHeight = 0.0
        width = self.view.frame.size.width
        halfHeight = (self.view.frame.size.height - navHeight!)/2
        height = self.view.frame.size.height
        let labelHeight = 40.0 as CGFloat
        var buttonheight = (self.view.frame.size.height / 10)
        
        self.lblPickup = UILabel(frame: CGRectMake(0, 80, width!, labelHeight))
        self.lblPickup!.numberOfLines = 1
        self.lblPickup!.font = UIFont (name: "Arial", size:28.0)
        self.lblPickup!.adjustsFontSizeToFitWidth = true
        self.lblPickup!.clipsToBounds = true
        self.lblPickup!.backgroundColor = UIColor.clearColor()
        self.lblPickup!.textColor = UIColor.blackColor()
        self.lblPickup!.textAlignment = NSTextAlignment.Center
        
        
        let toImage = "Down4-50.png"
        let image = UIImage(named: toImage)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: (self.view.bounds.size.width - imageView.frame.size.width) / 2.0 , y: 105, width: 90, height: 60)
        
        
        self.lblDelivery = UILabel(frame: CGRectMake(0, 150, width!, labelHeight))
        self.lblDelivery!.numberOfLines = 1
        self.lblDelivery!.font = UIFont (name: "Arial", size:28.0)
        self.lblDelivery!.adjustsFontSizeToFitWidth = true
        self.lblDelivery!.clipsToBounds = true
        self.lblDelivery!.backgroundColor = UIColor.clearColor()
        self.lblDelivery!.textColor = UIColor.blackColor()
        self.lblDelivery!.textAlignment = NSTextAlignment.Center
        
        self.lblTypeOfLoad = UILabel(frame: CGRectMake(0, 175, width!, labelHeight))
        self.lblTypeOfLoad!.numberOfLines = 1
        self.lblTypeOfLoad!.font = UIFont (name: "Arial", size:14.0)
        self.lblTypeOfLoad!.adjustsFontSizeToFitWidth = true
        self.lblTypeOfLoad!.clipsToBounds = true
        self.lblTypeOfLoad!.backgroundColor = UIColor.clearColor()
        self.lblTypeOfLoad!.textColor = UIColor.blackColor()
        self.lblTypeOfLoad!.textAlignment = NSTextAlignment.Center
        
        self.lblMiles = UILabel(frame: CGRectMake(0, 300, width!, labelHeight))
        self.lblMiles!.numberOfLines = 1
        self.lblMiles!.font = UIFont (name: "Arial", size:19.0)
        self.lblMiles!.adjustsFontSizeToFitWidth = true
        self.lblMiles!.clipsToBounds = true
        self.lblMiles!.backgroundColor = UIColor.clearColor()
        self.lblMiles!.textColor = UIColor.blackColor()
        self.lblMiles!.textAlignment = NSTextAlignment.Center
        
        self.lblWeight = UILabel(frame: CGRectMake(0, 350, width!, labelHeight))
        self.lblWeight!.numberOfLines = 1
        self.lblWeight!.font = UIFont (name: "Arial", size:19.0)
        self.lblWeight!.adjustsFontSizeToFitWidth = true
        self.lblWeight!.clipsToBounds = true
        self.lblWeight!.backgroundColor = UIColor.clearColor()
        self.lblWeight!.textColor = UIColor.blackColor()
        self.lblWeight!.textAlignment = NSTextAlignment.Center
        
        self.lblPricePerMile = UILabel(frame: CGRectMake(0, 400, width!, labelHeight))
        self.lblPricePerMile!.numberOfLines = 1
        self.lblPricePerMile!.font = UIFont (name: "Arial", size:19.0)
        self.lblPricePerMile!.adjustsFontSizeToFitWidth = true
        self.lblPricePerMile!.clipsToBounds = true
        self.lblPricePerMile!.backgroundColor = UIColor.clearColor()
        self.lblPricePerMile!.textColor = UIColor.blackColor()
        self.lblPricePerMile!.textAlignment = NSTextAlignment.Center
        
        self.lblNotes = UILabel(frame: CGRectMake(0, 450, width!, labelHeight))
        self.lblNotes!.numberOfLines = 1
        self.lblNotes!.font = UIFont (name: "Arial", size:19.0)
        self.lblNotes!.adjustsFontSizeToFitWidth = true
        self.lblNotes!.clipsToBounds = true
        self.lblNotes!.backgroundColor = UIColor.clearColor()
        self.lblNotes!.textColor = UIColor.blackColor()
        self.lblNotes!.textAlignment = NSTextAlignment.Center
        
        
        
        self.view.addSubview(self.lblPickup!)
        self.view.addSubview(imageView)
        self.view.addSubview(self.lblDelivery!)
        self.view.addSubview(self.lblTypeOfLoad!)
        self.view.addSubview(self.lblMiles!)
        self.view.addSubview(self.lblWeight!)
        self.view.addSubview(self.lblPricePerMile!)
        self.view.addSubview(self.lblNotes!)
        
        button.frame = CGRectMake((self.view.bounds.size.width - 100) / 2.0, buttonheight * 9, 100, 50)
        button.backgroundColor = UIColor(red:0.29, green:0.63, blue:0.95, alpha:1.0)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setTitle("Accept Bid", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        self.view.addSubview(button)
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        println(pickupAddressFull)
        
    }

    //Provide directions in new instance of MapViewController
    
    func provideDirections(){
        
                    self.manager = CLLocationManager()
                    self.manager.startUpdatingLocation()
                    println("Location Updated")

                    let request = MKDirectionsRequest()
                    request.setSource(MKMapItem.mapItemForCurrentLocation())
        
                    let latitude = (alat as NSString).doubleValue
                    let longitude = (alng as NSString).doubleValue
        
                    let destinationCoordinate = MKPlacemark(coordinate: CLLocationCoordinate2DMake(latitude, longitude), addressDictionary: nil)
        
                    var pickupVC = PickupViewController(frame: self.view.frame, destination: MKMapItem(placemark: destinationCoordinate))
        

                    self.navigationController?.pushViewController(pickupVC, animated: true)
                    pickupVC.getDirections()
                    pickupVC.configureToolbar()
                    pickupVC.pickupAddressFull = pickupAddressFull
                    pickupVC.phoneNumber = phoneNumber
                    pickupVC.contactName = contactName
                    pickupVC.blat = blat
                    pickupVC.blng = blng
                    pickupVC.deliveryAddressFull = deliveryAddressFull
    
    }
    func acceptLoad() {
        //Changing load from available to unavailable
// ************Find a way to display an error if between the time the map was loaded to the time they clicked Accept, The bid was taken and changed the available classname from true to false.*********************
        
//        var query = PFQuery(className:"load")
//        query.getObjectInBackgroundWithId(id) {
//            (load: PFObject?, error: NSError?) -> Void in
//            if error != nil {
//                println(error)
//            } else if let load = load {
//                load["available"] = false
//                println("changed")
//                load.saveInBackground()
//            }
//        } 
    }
    
    
    func buttonAction(sender:UIButton!)
    {
//***************Change the button alpha to 0 and perform the query and refresh the table. Hoefully this will solve the button alpha issue once another load is clicked.*******************
        
//***************If Statement for whether or not it conflicts with a current load that they have**********************
        
        CustomAlert().showAlert("Bid Accepted", subTitle: "", style: AlertStyle.Success)
        
        
        var rightBarButtonItem = UIBarButtonItem(title: "Route", style: UIBarButtonItemStyle.Plain, target: self, action: "provideDirections")
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.acceptLoad()
        
            }
}