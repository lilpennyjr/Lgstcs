//
//  LoginViewController.swift
//  Lgstcs
//
//  Created by Michael Latson on 6/25/15.
//  Copyright (c) 2015 Lgstcs Co. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!

    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func login(sender: AnyObject) {
        
        var user = PFUser()
        user.username = username.text
        user.password = password.text
        
        PFUser.logInWithUsernameInBackground(username.text, password:password.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if error != nil {
                
                var dVC = DriverViewController()
                
                self.navigationController?.pushViewController(dVC, animated: false)
                
            } else {
                println(error)
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
        
        // Do any additional setup after loading the view.
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
