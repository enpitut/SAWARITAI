//
//  DayViewController.swift
//  PoiPet
//
//  Created by koooootake on 2015/11/15.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class DayViewController: UIViewController,NSXMLParserDelegate,UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var DayTableView: UITableView!
    
   
    var pois:[PoiModel] = [PoiModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
                let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM月dd日";
        
        print("\(dateFormatter.stringFromDate(appDelegate.selectDay!))")
        
        
        self.title = "\(dateFormatter.stringFromDate(appDelegate.selectDay!))"
        
        DayTableView.delegate = self
        DayTableView.dataSource = self
        
        setDay()
    
    }
    
    class Poi {
        var id:String!
        var date:String!
        var month:String!
        var year:String!
        var time:String!
        var location:String!
    }
    
    func setDay(){
        
        for var i:Int = 0 ; i < appDelegate.poiTime.count ; i++ {
            let poi = PoiModel(time: "\(appDelegate.poiTime[i])", place: "\(appDelegate.poiPlace[i])")
            pois.append(poi)
        }
        
        appDelegate.poiTime = []
        appDelegate.poiPlace = []
        
    }
    
    // セクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pois.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell: DayTableViewCell = tableView.dequeueReusableCellWithIdentifier("DayTableViewCell", forIndexPath: indexPath) as! DayTableViewCell
        cell.setCell(pois[indexPath.row])
        
        return cell
    }

}
