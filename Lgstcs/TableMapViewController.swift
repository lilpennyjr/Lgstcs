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
  
            self.detailLoad?.lblPickup?.text = load.shipperCity + ", " + load.shipperState
            self.detailLoad?.lblDelivery?.text = load.deliveryCity + ", " + load.deliveryState
            self.detailLoad?.lblTypeOfLoad?.text = load.typeOfLoad
            self.detailLoad?.lblWeight?.text = "Weight: " + load.weight
            
            //Add + load.miles + load.pricePerMile + load.notes
            
            self.detailLoad?.lblMiles?.text = "Miles: "
            self.detailLoad?.lblPricePerMile?.text = "Price Per Mile: "
            self.detailLoad?.lblNotes?.text = "Notes: "
    
            self.detailLoad?.id = load.id
            self.detailLoad?.shipperAddressFull = load.shipperAddress + " " + load.shipperCity + ", " + load.shipperState
            self.detailLoad?.deliveryAddressFull = load.deliveryAddress + " " + load.deliveryCity + ", " + load.deliveryState
            

            self.detailLoad?.shipDate = load.shipDate
            self.detailLoad?.shipperName = load.shipperName
            self.detailLoad?.shipperCompany = load.shipperCompany
            self.detailLoad?.shipperAddress = load.shipperAddress
            self.detailLoad?.shipperCity = load.shipperCity
            self.detailLoad?.shipperState = load.shipperState
            self.detailLoad?.shipperPhone = load.shipperPhone
            self.detailLoad?.shipperEmail = load.shipperEmail
            self.detailLoad?.shipperLat = load.shipperLat
            self.detailLoad?.shipperLng = load.shipperLng
            
//            self.detailLoad?.deliveryDate = load.deliveryDate
            self.detailLoad?.deliveryName = load.deliveryName
            self.detailLoad?.deliveryAddress = load.deliveryAddress
            self.detailLoad?.deliveryCity = load.deliveryCity
            self.detailLoad?.deliveryState = load.deliveryState
            self.detailLoad?.deliveryPhone = load.deliveryPhone
            self.detailLoad?.deliveryLat = load.deliveryLat
            self.detailLoad?.deliveryLng = load.deliveryLng
            
            self.detailLoad?.weight = load.weight
            
        } else {
            println("no load at TableMapController")
        }
        self.navigationController?.pushViewController(self.detailLoad!, animated: true)
        
    }
    
    
    
}


