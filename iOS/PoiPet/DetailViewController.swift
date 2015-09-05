//
//  DetailViewController.swift
//  PoiPet
//
//  Created by koooootake on 2015/08/22.
//  Copyright (c) 2015年 koooootake. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var selectIdLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   self.title="Detail"
        self.view.backgroundColor=UIColor.whiteColor()
        selectIdLabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.width*3, self.view.frame.height))
        
        var appDelegate:AppDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
        var selectId=appDelegate.selectId
        selectIdLabel?.backgroundColor=UIColor.redColor()
        selectIdLabel?.text=selectId?.description
        selectIdLabel?.font=UIFont.systemFontOfSize(200)
        selectIdLabel?.textAlignment=NSTextAlignment.Center
        self.view.addSubview(selectIdLabel!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
