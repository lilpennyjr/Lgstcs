//
//  BOLSignatureViewController.swift
//  
//
//  Created by Michael Latson on 6/23/15.
//
//

import UIKit
import MapKit

class BOLSignatureViewController: UIViewController {
    
    var signatureView : SignatureView?
    var manager: CLLocationManager!
    var deliveryAddressFull = ""
    var deliveryName = ""
    var deliveryPhone = ""
    var deliveryLat = ""
    var deliveryLng = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Route", style: .Plain, target: self, action: "route")
        

        // Do any additional setup after loading the view.
    }
    
    func route() {
    
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
    deliveryVC.deliveryLat = deliveryLat
    deliveryVC.deliveryLng = deliveryLng
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        
        signatureView = SignatureView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        self.view.addSubview(signatureView!)
        
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
