//
//  TableMapViewController.swift
//  Lgstcs
//
//  Created by Michael Latson on 6/11/15.
//  Copyright (c) 2015 Lgstcs Co. All rights reserved.
//

import UIKit
import MapKit

class TableMapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var navHeight:CGFloat?
    var width:CGFloat?
    var halfHeight:CGFloat?
    var height:CGFloat?
    var firstPosition = true
    var tableController:LoadsTableView?
    var loads: Array<Load> = [Load]()
    var mapView:MapViewController?
    var tapFirstView:UIGestureRecognizer?
    var bigMap = false
    var detailLoad:LoadDetailViewController?
    
    
    
    convenience init(frame:CGRect){
        self.init(nibName: nil, bundle: nil)
        navHeight = 0.0
        width = frame.size.width
        halfHeight = (frame.size.height - navHeight!)/2
        height = frame.size.height
        
        title = "Driver Dashboard"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "mapViewTapped", name: "mapViewTapped", object: nil)
        
        mapView = MapViewController(frame: CGRectMake(0.0, navHeight!, width!, halfHeight!), destination:MKMapItem())
        
        tapFirstView = UITapGestureRecognizer(target: self, action: "mapViewTapped")
        mapView!.view.addGestureRecognizer(tapFirstView!)
        self.view.addSubview(self.mapView!.view)
        
        tableController = LoadsTableView(frame: CGRectMake(0.0, halfHeight!, width!, halfHeight!))
        view.addSubview(tableController!.view)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "navigateToDetail:", name: "navigateToDetail", object: nil)
        
    }
    
    func mapViewTapped(){
        if (!bigMap){
            UIView.animateWithDuration(0.5,
                delay: 0,
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 20.0,
                options: UIViewAnimationOptions.CurveEaseIn ,
                animations: {
                    self.mapView!.view.frame = CGRectMake(0.0, self.navHeight!, self.width!, self.height!)
                    self.mapView!.map!.frame = CGRectMake(0.0, self.navHeight!, self.width!, self.height!)
                    self.tableController!.view.center = CGPointMake(self.tableController!.view.center.x, self.tableController!.view.center.y+self.halfHeight!);
                },
                completion:{ (Bool)  in
                    let rightBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Delete Sign-50"), style: UIBarButtonItemStyle.Plain, target: self, action: "reverse")
                    self.navigationItem.rightBarButtonItem = rightBarButtonItem
                    self.bigMap = true
            })
        }
    }
    
    func reverse(){
        if bigMap {
            UIView.animateWithDuration(0.5,
                delay: 0,
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 20.0,
                options: UIViewAnimationOptions.CurveEaseIn ,
                animations: {
                    self.mapView!.view.frame = CGRectMake(0.0, self.navHeight!, self.width!, self.halfHeight!)
                    self.mapView!.map!.frame = CGRectMake(0.0, self.navHeight!, self.width!, self.halfHeight!)
                    self.tableController!.view.center = CGPointMake(self.tableController!.view.center.x, self.tableController!.view.center.y-self.halfHeight!);
                },
                completion:{ (Bool)  in
                    self.navigationItem.rightBarButtonItem = nil
                    self.bigMap = false
                    
                    if let selectedAnnotations = self.mapView!.map!.selectedAnnotations as? [MapPointAnnotation]{
                        for annotation in selectedAnnotations {
                            self.mapView!.map!.deselectAnnotation(annotation, animated: true)
                            
                            
                        }
                    }
            })
        }
        
    }
    
    func setLoadCollection(array: [Load]!) {
        if (array != nil) {
            loads = array!
            tableController!.loadLoads(array!)
            mapView!.loadPointsWithArray(array!)
        }
    }
    
    func navigateToDetail(notification:NSNotification){
        
        if self.detailLoad == nil {
            self.detailLoad = LoadDetailViewController()
        }
        if let load:Load = notification.object as? Load {
  
            self.detailLoad?.lblPickup?.text = load.pickupCity + ", " + load.pickupState
            self.detailLoad?.lblDelivery?.text = load.deliveryCity + ", " + load.deliveryState
            self.detailLoad?.lblTypeOfLoad?.text = load.typeOfLoad
            self.detailLoad?.lblWeight?.text = "Weight: " + load.weight
            self.detailLoad?.id = load.id
            self.detailLoad?.alat = load.alat
            self.detailLoad?.alng = load.alng
            
            //Add + load.miles + load.pricePerMile + load.notes
            
            self.detailLoad?.lblMiles?.text = "Miles: "
            self.detailLoad?.lblPricePerMile?.text = "Price Per Mile: "
            self.detailLoad?.lblNotes?.text = "Notes: "
            self.detailLoad?.pickupAddressFull = load.pickupAddress + " " + load.pickupCity + ", " + load.pickupState
            self.detailLoad?.phoneNumber = load.phoneNumber
            self.detailLoad?.contactName = load.contactName
            self.detailLoad?.blat = load.blat
            self.detailLoad?.blng = load.blng
            self.detailLoad?.deliveryAddressFull = load.deliveryAddress + " " + load.deliveryCity + ", " + load.deliveryState
            
        } else {
            println("no load at TableMapController")
        }
        self.navigationController?.pushViewController(self.detailLoad!, animated: true)
        
    }
    
    
    
}


