//
//  MapViewController.swift
//  Lgstcs
//
//  Created by Michael Latson on 6/11/15.
//  Copyright (c) 2015 Lgstcs Co. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var loadPoints:[Int: MapPointAnnotation] = [Int:MapPointAnnotation]()
    var map:MKMapView?
    var loads: [Load]?
    var rightButton: UIButton?
    var selectedLoad:Load?
    var manager: CLLocationManager!
    var destination: MKMapItem?
    
    convenience init(frame:CGRect, destination:MKMapItem){
        self.init(nibName: nil, bundle: nil)
        self.destination = destination
        self.view.frame = frame
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"selectAnnotation:", name: "selectAnnotation", object: nil)
        
        self.map = MKMapView(frame: frame)
        self.map!.delegate = self
        
        self.view.addSubview(self.map!)
        
        //Get user location
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        //Update region for user location then stop updating location to save battery life
        
        var userLocation:CLLocation = locations[0] as! CLLocation
        var latitude:CLLocationDegrees = userLocation.coordinate.latitude
        var longitude:CLLocationDegrees = userLocation.coordinate.longitude
        var latDelta:CLLocationDegrees = 1.15
        var lonDelta:CLLocationDegrees = 1.15
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        map!.setRegion(region, animated: true)
        manager.stopUpdatingLocation()
    }
    
    func loadPointsWithArray(someLoads:[Load]){
        map!.removeAnnotations(map!.annotations)
        for (var i=0; i<someLoads.count; i++) {
            
            var point:MapPointAnnotation = MapPointAnnotation()
            var v = someLoads[i] as Load
            point.load = v
            let latitude = (v.alat as NSString).doubleValue
            let longitude = (v.alng as NSString).doubleValue
            point.coordinate = CLLocationCoordinate2DMake(latitude,longitude);
            point.title = v.pickupCity as String + ", " + v.pickupState as String + " to " + v.deliveryCity as String + ", " + v.deliveryState
            point.subtitle = v.typeOfLoad
            loadPoints[v.ident] = point
            
            map!.addAnnotation(point)
        }
    }
    
    // select load from tableview
    func selectAnnotation(notification :NSNotification)  {
        self.selectedLoad = notification.object as? Load
        var point:MKPointAnnotation = loadPoints[self.selectedLoad!.ident]!
        map!.selectAnnotation(point, animated: true)
    }
    
    //select load from mapview
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        
        
        let p = view.annotation as! MapPointAnnotation
        self.selectedLoad = p.load
        println("\(p.load)")
        
    } 
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinColor = .Red
            
            
            if self.rightButton == nil {
                self.rightButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as? UIButton
            }
            
            self.rightButton!.titleForState(UIControlState.Normal)
            
            self.rightButton!.addTarget(self, action: "rightButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            pinView!.rightCalloutAccessoryView = self.rightButton! as UIView
            
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func rightButtonTapped(sender: UIButton!){
        if let load:Load = selectedLoad {
            
            println("Load pickup:\(load.pickupCity)")
            
            NSNotificationCenter.defaultCenter().postNotificationName("navigateToDetail", object: load)
            
        } else {
            println("no load")
        }
    }
        
    override func viewDidLoad() {

    }
}
