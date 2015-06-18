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
    var alat: String
    var alng: String
    var pickupAddress: String
    var pickupCity: String
    var pickupState: String
    var deliveryAddress: String
    var deliveryCity: String
    var deliveryState: String
    var blat: String
    var blng: String
    var typeOfLoad: String
    var weight: String
    var id: String
    var phoneNumber: String
    var contactName: String
    
    init(aIdent:Int, aPickupAddress: String,  aPickupCity: String, aPickupState: String,aALat: String, aALng: String, aDeliveryAddress: String, aDeliveryCity: String, aDeliveryState: String, aBLat: String, aBLng: String, aTypeOfLoad: String, aWeight: String, aId: String, aPhoneNumber: String, aContactName: String){
        ident = aIdent
        pickupAddress = aPickupAddress
        pickupCity = aPickupCity
        pickupState = aPickupState
        alat = aALat
        alng = aALng
        deliveryAddress = aDeliveryAddress
        deliveryCity = aDeliveryCity
        deliveryState = aDeliveryState
        blat = aBLat
        blng = aBLng
        typeOfLoad = aTypeOfLoad
        weight = aWeight
        id = aId
        phoneNumber = aPhoneNumber
        contactName = aContactName
    
    }
    
}
