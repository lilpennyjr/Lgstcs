//
//  BillOfLadingViewController.swift
//  Lgstcs
//
//  Created by Michael Latson on 6/20/15.
//  Copyright (c) 2015 Lgstcs Co. All rights reserved.
//

import UIKit
import SwiftForms
import Parse
import MapKit

class BillOfLadingViewController: FormViewController {
    
    var manager: CLLocationManager!
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
    
    var carrierName = ""
    
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

    
    
    
    struct Static {
        static let pickupDate = "pickupDate"
        static let shipperCompany = "shipperCompany"
        static let shipperName = "shipperName"
        static let shipperAddress = "shipperAddress"
        static let shipperCity = "shipperCity"
        static let shipperState = "shipperState"
        static let shipperPhone = "shipperPhone"
        static let shipperEmail = "shipperEmail"
        
        static let carrierName = "carrierName"
        static let carrierAddress = "carrierAddress"
        static let carrierCity = "carrierCity"
        static let carrierState = "carrierState"
        static let carrierPhone = "carrierPhone"
        static let carrierSCAC = "carrierSCAC"
        static let carrierEmail = "carrierEmail"
        
        static let deliveryDate = "deliveryDate"
        static let deliveryName = "deliveryName"
        static let deliveryAddress = "deliveryAddress"
        static let deliveryCity = "deliveryCity"
        static let deliveryState = "deliveryState"
        static let deliveryPhone = "deliveryPhone"
        
        static let weight = "weight"
        static let units = "units"
        static let mileage = "mileage"
        static let check = "check"
     
        
    }
    
    
    convenience init () {
        self.init(nibName: nil, bundle: nil)
        self.loadForm()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Route", style: .Plain, target: self, action: "route:")
        self.navigationItem.hidesBackButton = true
        self.loadForm()
    }
    
    /// MARK: Actions
    
    func route(_: UIBarButtonItem!) {
               // println(form.formValues().description)
        println(form)
      
        
        self.manager = CLLocationManager()
        self.manager!.startUpdatingLocation()
        println("Location Updated")
        
        let request = MKDirectionsRequest()
        request.setSource(MKMapItem.mapItemForCurrentLocation())
        
        let latitude = (deliveryLat as NSString).doubleValue
        let longitude = (deliveryLng as NSString).doubleValue
        
        let deliveryCoordinate = MKPlacemark(coordinate: CLLocationCoordinate2DMake(latitude, longitude), addressDictionary: nil)
        
        
        var deliveryVC = DeliveryViewController(frame: self.view.frame, delivery: MKMapItem(placemark: deliveryCoordinate))
        
        self.navigationController?.pushViewController(deliveryVC, animated: false)
        deliveryVC.getDirections()
        deliveryVC.configureToolbar()
        deliveryVC.deliveryAddressFull = deliveryAddressFull
        deliveryVC.deliveryPhone = deliveryPhone
        deliveryVC.deliveryName = deliveryName
        
    }
    
    /// MARK: Private interface
    
     func loadForm() {
        
        
        let form = FormDescriptor()
        
        form.title = "Bill of Lading"
        
        let section1 = FormSectionDescriptor()
        
        var row: FormRowDescriptor! = FormRowDescriptor(tag: Static.pickupDate, rowType: .DateAndTime, title: "Pickup Date")
        section1.addRow(row)
        
        row = FormRowDescriptor(tag: Static.shipperCompany, rowType: .Name, title: "Company")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Shipper Company", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.value = shipperCompany
        section1.addRow(row)

        
        row = FormRowDescriptor(tag: Static.shipperName, rowType: .Name, title: "Name")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Contact name", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.value = shipperName
        section1.addRow(row)
        
        
        row = FormRowDescriptor(tag: Static.shipperAddress, rowType: .Text, title: "Address")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Enter address", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.value = shipperAddress
        section1.addRow(row)
        
        row = FormRowDescriptor(tag: Static.shipperCity, rowType: .Text, title: "City")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Enter city", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.value = shipperCity
        section1.addRow(row)
        
        row = FormRowDescriptor(tag: Static.shipperState, rowType: .Text, title: "State")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Enter state", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.value = shipperState
        section1.addRow(row)
        
        row = FormRowDescriptor(tag: Static.shipperPhone, rowType: .Phone, title: "Phone")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Enter phone", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.value = shipperPhone
        section1.addRow(row)
        
        row = FormRowDescriptor(tag: Static.shipperEmail, rowType: .Email, title: "Email")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Enter email", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.value = shipperEmail
        section1.addRow(row)
        
        section1.headerTitle = "Shipper Information"
        
        
        
        let section2 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.carrierName, rowType: .Name, title: "Name")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Carrier name", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section2.addRow(row)
        
        row = FormRowDescriptor(tag: Static.carrierSCAC, rowType: .Text, title: "SCAC")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Enter SCAC", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section2.addRow(row)
        
        row = FormRowDescriptor(tag: Static.carrierAddress, rowType: .Text, title: "Address")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Enter address", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section2.addRow(row)
        
        row = FormRowDescriptor(tag: Static.carrierCity, rowType: .Text, title: "City")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Enter city", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section2.addRow(row)
        
        row = FormRowDescriptor(tag: Static.carrierState, rowType: .Text, title: "State")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Enter state", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section2.addRow(row)
        
        row = FormRowDescriptor(tag: Static.carrierPhone, rowType: .Phone, title: "Phone")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Enter phone", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section2.addRow(row)
        
        row = FormRowDescriptor(tag: Static.carrierEmail, rowType: .Email, title: "Email")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Enter email", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section2.addRow(row)
        
        section2.headerTitle = "Carrier Information"
        
        
        
        
        
        
        
        let section3 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.deliveryName, rowType: .Name, title: "Name")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Contact name", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.value = deliveryName
        section3.addRow(row)
        
        row = FormRowDescriptor(tag: Static.deliveryAddress, rowType: .Text, title: "Address")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Enter address", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.value = deliveryAddress
        section3.addRow(row)
        
        row = FormRowDescriptor(tag: Static.deliveryCity, rowType: .Text, title: "City")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Enter city", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.value = deliveryCity
        section3.addRow(row)
        
        row = FormRowDescriptor(tag: Static.deliveryState, rowType: .Text, title: "State")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Enter state", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.value = deliveryState
        section3.addRow(row)
        
        row = FormRowDescriptor(tag: Static.deliveryPhone, rowType: .Phone, title: "Phone")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Enter phone", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        row.value = deliveryPhone
        section3.addRow(row)
        
        section3.headerTitle = "Delivery Information"
        
        
        
        
    
        let section4 = FormSectionDescriptor()
        
        
        row = FormRowDescriptor(tag: Static.weight, rowType: .Number, title: "Weight")
        row.value = weight
        section4.addRow(row)
        
        row = FormRowDescriptor(tag: Static.units, rowType: .Number, title: "Units")
        section4.addRow(row)
        
        row = FormRowDescriptor(tag: Static.mileage, rowType: .Number, title: "Mileage")
        // Calculate the distance based upon the destination and the delivery location??
        section4.addRow(row)
        
        row = FormRowDescriptor(tag: Static.check, rowType: .BooleanSwitch, title: "Certify this information")
        section4.addRow(row)
        
        section4.headerTitle = "Load Information"
        
        
        
        form.sections = [section1, section2, section3, section4,]
        
        self.form = form
    }
}
