//
//  LoadsTableView.swift
//  Lgstcs
//
//  Created by Michael Latson on 6/11/15.
//  Copyright (c) 2015 Lgstcs Co. All rights reserved.
//

import UIKit

class LoadsTableView: UITableViewController,UITableViewDelegate, UITableViewDataSource {
    
    var loads: [Load] = []
    var rightButton:UIButton?
    let cellId = "cell"
    
    
    
    convenience init(frame:CGRect){ 
        self.init(style:.Plain)
        self.title = "Plain Table"
        self.view.frame = frame
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellId)
    }
    
    func loadLoads(array: [Load]) {
        self.loads = array
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.loads.count as Int
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellId, forIndexPath: indexPath) as! UITableViewCell
        
        var load = self.loads[indexPath.row] as Load
        var attachment = NSTextAttachment()
        attachment.image = UIImage(named: "Right-50.png")
        var attachmentString = NSAttributedString(attachment: attachment)
        var attachmentString2 = NSAttributedString(string: load.deliveryCity + ", " + load.deliveryState)
        var arrowIcon = NSMutableAttributedString(string: load.shipperCity + ", " + load.shipperState)
        arrowIcon.appendAttributedString(attachmentString)
        arrowIcon.appendAttributedString(attachmentString2)
        cell.textLabel!.attributedText = arrowIcon
        
        println("Point Location: \(load.shipperLat) \(load.shipperLng) \(load.weight)")
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        var cell = self.tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell?
        println(cell?.textLabel?.text)
        NSNotificationCenter.defaultCenter().postNotificationName("mapViewTapped", object: nil)
        let load:Load = self.loads[indexPath.row] as Load
        NSNotificationCenter.defaultCenter().postNotificationName("selectAnnotation", object: load)
    }
}
