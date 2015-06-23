//
//  DirectionsViewController.swift
//  Lgstcs
//
//  Created by Michael Latson on 6/14/15.
//  Copyright (c) 2015 Lgstcs Co. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PickupViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var map: MKMapView?
    var manager: CLLocationManager?
    var destination: MKMapItem?
    let toolbar = UIToolbar()
    let annotation = MKPointAnnotation()
    var course: CLLocationDirection?
    var camera: MKMapCamera?
    var label: TopAlignedLabel?
    var callPhoneNumber = UIButton.buttonWithType(UIButtonType.System) as! UIButton
    let arrivedButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
    var shipperAddressFull = ""
    var shipperLat = ""
    var shipperLng = ""
    
    var shipperName = ""
    var shipperCompany = ""
    var shipperAddress = ""
    var shipperCity = ""
    var shipperState = ""
    var shipperPhone = ""
    var shipperEmail = ""
    
    var deliveryName = ""
    var deliveryAddress = ""
    var deliveryCity = ""
    var deliveryState = ""
    var deliveryPhone = ""
    
    var weight = ""
    var units = ""
    var mileage = ""
    
    var deliveryAddressFull = ""
    var deliveryLat = ""
    var deliveryLng = ""
    
    
    
    convenience init(frame:CGRect, destination:MKMapItem){
        self.init(nibName: nil, bundle: nil)
        self.destination = destination
        self.view.frame = frame
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"selectAnnotation:", name: "selectAnnotation", object: nil)
        
        self.map = MKMapView(frame: frame)
        self.map!.delegate = self
        
        self.view.addSubview(self.map!)
        
        manager = CLLocationManager()
        manager!.delegate = self
        manager!.desiredAccuracy = kCLLocationAccuracyBest
        manager!.startUpdatingLocation()
        self.map?.showsUserLocation = true
        
        
    }

    func configureToolbar() {
        
        //Creates a Cancel button, gets rid of the back button in navigation controller
        
        var cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelRoute")
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
        self.navigationItem.setHidesBackButton(true, animated: true)
       
        toolbar.frame = CGRectMake(0, self.view.frame.size.height - 45, self.view.frame.size.width, 0)
        toolbar.sizeToFit()
        toolbar.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(toolbar)
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let toolbarButtonItems = [
            locationBarButtonItem, flexSpace, startBarButtonItem
        ]
        toolbar.setItems(toolbarButtonItems, animated: true)
        
    }
    
    // UIBarButtonItem Creation and Configuration
    // Change the action from nil to getting the users current location

    var locationBarButtonItem: UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: "compass_2.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "currentLoc")
    }
    
    var startBarButtonItem: UIBarButtonItem {
        return UIBarButtonItem(title: "Start", style: UIBarButtonItemStyle.Plain, target: self, action: "startNavigation")
    }
    
    var steps: UIBarButtonItem {
        return UIBarButtonItem(title: "Steps", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
    }
    
    func startNavigation(){
        //Set up the Camera
        let mapCamera = MKMapCamera(lookingAtCenterCoordinate: manager!.location.coordinate, fromEyeCoordinate: manager!.location.coordinate, eyeAltitude: 4700)
        map!.setCamera(mapCamera, animated: true)
        
        //Start Tracking User
        //        map!.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        
        //Creates Label for Directions
        var fifthwidth = (self.view.frame.size.width / 5)
        
        
        var lblDirections = UILabel(frame: CGRectMake(fifthwidth, 65, (fifthwidth * 4), fifthwidth))
        lblDirections.text = "Placeholder for Directions"
        lblDirections.numberOfLines = 2
        lblDirections.font = UIFont (name: "Arial", size:20)
        lblDirections.adjustsFontSizeToFitWidth = true
        lblDirections.clipsToBounds = true
        lblDirections.backgroundColor = UIColor.whiteColor()
        lblDirections.textColor = UIColor.blackColor()
        lblDirections.textAlignment = NSTextAlignment.Center
        lblDirections.alpha = 0.90
        
        var imageDirections = "TurnLeft.png"
        var image = UIImage(named: imageDirections)
        var imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x:  0, y: 65, width: fifthwidth, height: fifthwidth)
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.whiteColor()
        imageView.alpha = 0.90
        
        self.view.addSubview(imageView)
        self.view.addSubview(lblDirections)
        
    }
    
    
    func mapView(mapView: MKMapView!, rendererForOverlay
        overlay: MKOverlay!) -> MKOverlayRenderer! {
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = UIColor.blueColor()
            renderer.lineWidth = 5.0
            return renderer
    }
    
    
    
    
    
    func getDirections() {
        
        let request = MKDirectionsRequest()
        request.setSource(MKMapItem.mapItemForCurrentLocation())
        request.setDestination(destination!)
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler({(response:
            MKDirectionsResponse!, error: NSError!) in
            
            if error != nil {
                println(error)
            } else {
                self.showRoute(response)
            }
            
        })
    }

    
    func showRoute(response: MKDirectionsResponse) {
        
        for route in response.routes as! [MKRoute] {
            
            self.map!.addOverlay(route.polyline,
                level: MKOverlayLevel.AboveRoads)
            
            var myPolyline = route.polyline
            
            let edgeInset = UIEdgeInsetsMake(75, 75, 75, 75)
            
            self.map!.setVisibleMapRect(myPolyline.boundingMapRect, edgePadding: edgeInset, animated: true)
            
            for step in route.steps {
                println(step.instructions)
            }
        }
        
        let userLocation = self.map!.userLocation
        //   let region = MKCoordinateRegionMakeWithDistance(
        //   userLocation.location!.coordinate, 2000, 2000)
        
        //   map!.setRegion(region, animated: true)
    }
    
    func currentLoc() {
        map!.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        
    }
    
    func cancelRoute(){
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func calling(sender: UIButton) {
        
        let phone = shipperPhone
        let url:NSURL = NSURL(string:phone)!;
        UIApplication.sharedApplication().openURL(url)
        println("Calling")
    }
    
    func arrivedToPickUpLocation(sender: UIButton) {
        
        var buttonheight = (view.frame.size.height / 10)
        
        
        UIView.animateWithDuration(0.25, animations: { self.label!.frame  = CGRectMake(0, buttonheight*10, self.view.frame.width, buttonheight*3 - 45)})
        
        UIView.animateWithDuration(0.25, animations: { self.arrivedButton.frame  = CGRectMake(0, buttonheight*10, self.view.frame.width,buttonheight*3 - 45)})
        
        UIView.animateWithDuration(0.25, animations: { self.callPhoneNumber.frame  = CGRectMake(0, buttonheight*10, self.view.frame.width,buttonheight*3 - 45)})
        
        var rightBarButtonItem = UIBarButtonItem(title: "BOL", style: UIBarButtonItemStyle.Plain, target: self, action: "bol")
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func bol() {
        
        
        var bolVC = BillOfLadingViewController()
        
        self.navigationController?.pushViewController(bolVC, animated: true)
        
        bolVC.shipperAddressFull = shipperAddressFull
        bolVC.shipperLat = shipperLat
        bolVC.shipperLng = shipperLng
        
        bolVC.shipperName = shipperName
        bolVC.shipperCompany = shipperCompany
        bolVC.shipperAddress = shipperAddress
        bolVC.shipperCity = shipperCity
        bolVC.shipperState = shipperState
        bolVC.shipperPhone = shipperPhone
        bolVC.shipperEmail = shipperEmail
        
        bolVC.deliveryName = deliveryName
        bolVC.deliveryAddress = deliveryAddress
        bolVC.deliveryCity = deliveryCity
        bolVC.deliveryState = deliveryState
        bolVC.deliveryPhone = deliveryPhone
        
        bolVC.weight = weight
        
        
        bolVC.deliveryAddressFull = deliveryAddressFull
        bolVC.deliveryLat = deliveryLat
        bolVC.deliveryLng = deliveryLng

        
        
    }
    
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
//        if region is CLCircularRegion {
            println("Entered")
            
            var buttonheight = (view.frame.size.height / 10)
        
            self.label = TopAlignedLabel(frame: CGRectMake(0, buttonheight * 10, self.view.frame.width, buttonheight*3 - 45))
            self.label!.numberOfLines = 0
            self.label!.font = UIFont (name: "Arial", size:18.0)
            self.label!.adjustsFontSizeToFitWidth = true
            self.label!.clipsToBounds = true
            self.label!.backgroundColor = UIColor(red:0.43, green:0.43, blue:0.43, alpha:1.0)
            self.label!.textColor = UIColor.whiteColor()
            self.label!.text = shipperAddressFull + "\n"
            self.label!.textAlignment = NSTextAlignment.Center
            UIView.animateWithDuration(0.25, animations: { self.label!.frame  = CGRectMake(0, buttonheight*7, self.view.frame.width,buttonheight*3 - 45)})
            
        self.view.addSubview(self.label!)
    
            
            callPhoneNumber.frame = CGRectMake((self.view.bounds.size.width - 250) / 2.0, buttonheight * 10, 250, 50)
            callPhoneNumber.backgroundColor = UIColor.clearColor()
            callPhoneNumber.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            callPhoneNumber.setTitle(shipperName + ": " + shipperPhone, forState: UIControlState.Normal)
            callPhoneNumber.addTarget(self, action: "calling:", forControlEvents: UIControlEvents.TouchUpInside)
            callPhoneNumber.titleLabel!.font = UIFont (name: "Arial", size:14.0)
            callPhoneNumber.layer.cornerRadius = 10
            callPhoneNumber.clipsToBounds = true
            
            UIView.animateWithDuration(0.25, animations: { self.callPhoneNumber.frame  = CGRectMake((self.view.frame.width - 250)/2, buttonheight*7.2, 250,50)})
            
            self.view.addSubview(callPhoneNumber)
            
    
    
            var width = self.view.frame.width / 5
            
            arrivedButton.frame = CGRectMake((self.view.bounds.size.width - (width * 4.75)) / 2.0, buttonheight * 10, width * 4.75, 50)
            arrivedButton.backgroundColor = UIColor(red:0.32, green:0.87, blue:0.32, alpha:1.0)
            arrivedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            arrivedButton.setTitle("Arrived", forState: UIControlState.Normal)
            arrivedButton.addTarget(self, action: "arrivedToPickUpLocation:", forControlEvents: UIControlEvents.TouchUpInside)
            arrivedButton.titleLabel!.font = UIFont (name: "Arial", size:20.0)
            arrivedButton.layer.cornerRadius = 10
            arrivedButton.clipsToBounds = true
            
            UIView.animateWithDuration(0.25, animations: { self.arrivedButton.frame  = CGRectMake((self.view.bounds.size.width - (width * 4.75)) / 2.0, buttonheight*8, width * 4.75,50)})
        
            self.view.addSubview(arrivedButton)
        
            var center: CLLocationCoordinate2D = destination!.placemark.coordinate
            var radius: CLLocationDistance = CLLocationDistance(300)
            var identifier: String = "Destination"
            let region = CLCircularRegion(center: center, radius: radius, identifier: identifier)
            manager.stopMonitoringForRegion(region)
            
    }
    
        
        func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
            println("Did Fail")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view
            
        }
    
        
        override func viewDidAppear(animated: Bool) {
            
            self.annotation.title = shipperAddressFull
            annotation.coordinate = destination!.placemark.coordinate
            map!.addAnnotation(annotation)
            
            var center: CLLocationCoordinate2D = destination!.placemark.coordinate
            var radius: CLLocationDistance = CLLocationDistance(300)
            var identifier: String = "Destination"
            let region = CLCircularRegion(center: center, radius: radius, identifier: identifier)
            manager!.startMonitoringForRegion(region)
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        /*
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        }
        */
        
    
}
