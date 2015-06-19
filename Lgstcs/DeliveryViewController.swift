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

class DeliveryViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var map: MKMapView?
    var manager: CLLocationManager?
    var delivery: MKMapItem?
    var course: CLLocationDirection?
    var camera: MKMapCamera?
    var deliveryAddressFull: String?
    var label: TopAlignedLabel?
    let arrivedButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
    var blat = ""
    var blng = ""
    let toolbar = UIToolbar()
    
    
    
    convenience init(frame:CGRect, delivery:MKMapItem){
        self.init(nibName: nil, bundle: nil)
        self.delivery = delivery
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
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = delivery.placemark.coordinate
        annotation.title = deliveryAddressFull
        map!.addAnnotation(annotation)
        
    }
    
    func configureToolbar() {
        
        //Creates a Cancel button, gets rid of the back button in navigation controller
        
        var leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelRoute")
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
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
    
    // MARK: UIBarButtonItem Creation and Configuration
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
        
        var center: CLLocationCoordinate2D = delivery!.placemark.coordinate
        var radius: CLLocationDistance = CLLocationDistance(300)
        var identifier: String = "Destination"
        let region = CLCircularRegion(center: center, radius: radius, identifier: identifier)
        manager?.startMonitoringForRegion(region)
        
    
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
        request.setDestination(delivery!)
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
            
            let edgeInset = UIEdgeInsetsMake(10, 10, 10, 10)
            
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
 
    func arrivedToDeliveryLocation(sender: UIButton) {
        
        var buttonheight = (view.frame.size.height / 10)
        
        
        UIView.animateWithDuration(0.25, animations: { self.label!.frame  = CGRectMake(0, buttonheight*10, self.view.frame.width, buttonheight*3 - 45)})
        UIView.animateWithDuration(0.25, animations: { self.arrivedButton.frame  = CGRectMake(0, buttonheight*10, self.view.frame.width,buttonheight*3 - 45)})
        
        var rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("Entered")
        
        var buttonheight = (view.frame.size.height / 10)
        
        self.label = TopAlignedLabel(frame: CGRectMake(0, buttonheight * 10, self.view.frame.width, buttonheight*3 - 45))
        self.label!.numberOfLines = 0
        self.label!.font = UIFont (name: "Arial", size:16.0)
        self.label!.adjustsFontSizeToFitWidth = true
        self.label!.clipsToBounds = true
        self.label!.backgroundColor = UIColor(red:0.43, green:0.43, blue:0.43, alpha:1.0)
        self.label!.textColor = UIColor.whiteColor()
        self.label!.text = deliveryAddressFull! + "\n"
        self.label!.textAlignment = NSTextAlignment.Center
        UIView.animateWithDuration(0.25, animations: { self.label!.frame  = CGRectMake(0, buttonheight*7, self.view.frame.width,buttonheight*3 - 45)})
        
        self.view.addSubview(self.label!)
        
        
        
        var width = self.view.frame.width / 5
        
        arrivedButton.frame = CGRectMake((self.view.bounds.size.width - (width * 4.75)) / 2.0, buttonheight * 10, width * 4.75, 50)
        arrivedButton.backgroundColor = UIColor(red:0.32, green:0.87, blue:0.32, alpha:1.0)
        arrivedButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        arrivedButton.setTitle("Arrived", forState: UIControlState.Normal)
        arrivedButton.addTarget(self, action: "arrivedToDeliveryLocation:", forControlEvents: UIControlEvents.TouchUpInside)
        arrivedButton.titleLabel!.font = UIFont (name: "Arial", size:20.0)
        arrivedButton.layer.cornerRadius = 10
        arrivedButton.clipsToBounds = true
        
        UIView.animateWithDuration(0.25, animations: { self.arrivedButton.frame  = CGRectMake((self.view.bounds.size.width - (width * 4.75)) / 2.0, buttonheight*8, width * 4.75,50)})
        
        self.view.addSubview(arrivedButton)
        
        var center: CLLocationCoordinate2D = delivery!.placemark.coordinate
        var radius: CLLocationDistance = CLLocationDistance(300)
        var identifier: String = "Destination"
        let region = CLCircularRegion(center: center, radius: radius, identifier: identifier)
        manager.stopMonitoringForRegion(region)

        
    }
    
//      func locationManager(manager: CLLocationManager!, didExitRegion: CLRegion) {
//
//        var buttonheight = (view.frame.size.height / 10)
//        
//        UIView.animateWithDuration(0.25, animations: { self.label!.frame  = CGRectMake(0, buttonheight*10, self.view.frame.width, buttonheight*3 - 45)})
//        UIView.animateWithDuration(0.25, animations: { self.arrivedButton.frame  = CGRectMake(0, buttonheight*10, self.view.frame.width,buttonheight*3 - 45)})
//            
//        }
//        
        func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
            println("Did Fail")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
            
        }
        
        override func viewDidAppear(animated: Bool) {
            

            
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