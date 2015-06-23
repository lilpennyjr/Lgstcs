//
//  Load.swift
//  Lgstcs
//
//  Created by Michael Latson on 6/11/15.
//  Copyright (c) 2015 Lgstcs Co. All rights reserved.
//

import Foundation

class Load { 
    
    var ident: Int
    var shipperName: String
    var shipperCompany: String
    var shipperAddress: String
    var shipperCity: String
    var shipperState: String
    var shipperPhone: String
    var shipperEmail: String
    var shipperLat: String
    var shipperLng: String
    var deliveryName: String
    var deliveryAddress: String
    var deliveryCity: String
    var deliveryState: String
    var deliveryPhone: String
    var deliveryLat: String
    var deliveryLng: String
    var typeOfLoad: String
    var weight: String
    var id: String
    
    init(aIdent:Int, aShipperName: String, aShipperCompany: String, aShipperAddress: String,  aShipperCity: String, aShipperState: String, aShipperPhone: String, aShipperEmail: String, aShipperLat: String, aShipperLng: String, aDeliveryName: String, aDeliveryAddress: String, aDeliveryCity: String, aDeliveryState: String, aDeliveryPhone: String, aDeliveryLat: String, aDeliveryLng: String, aTypeOfLoad: String, aWeight: String, aId: String){
        
        ident = aIdent
        shipperName = aShipperName
        shipperCompany = aShipperCompany
        shipperPhone = aShipperPhone
        shipperAddress = aShipperAddress
        shipperCity = aShipperCity
        shipperState = aShipperState
        shipperPhone = aShipperPhone
        shipperEmail = aShipperEmail
        shipperLat = aShipperLat
        shipperLng = aShipperLng
        deliveryName = aDeliveryName
        deliveryAddress = aDeliveryAddress
        deliveryCity = aDeliveryCity
        deliveryState = aDeliveryState
        deliveryPhone = aDeliveryPhone
        deliveryLat = aDeliveryLat
        deliveryLng = aDeliveryLng
        typeOfLoad = aTypeOfLoad
        weight = aWeight
        id = aId
        
    
    }
    
}
