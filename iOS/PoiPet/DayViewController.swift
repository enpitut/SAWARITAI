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
    
    @IBOutlet weak var poikunView: UIView!
    @IBOutlet weak var poikunLabel: UILabel!
    var pois:[PoiModel] = [PoiModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
                let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM月dd日";
        
        print("SELECT:\(dateFormatter.stringFromDate(appDelegate.selectDay!))")
        
        switch appDelegate.poiWeek!{
        case 0:
            self.title = "\(dateFormatter.stringFromDate(appDelegate.selectDay!)) 日曜日"
            poikunView.backgroundColor = UIColor(red: 217/255.0, green: 150/255.0, blue: 148/255.0, alpha: 1.0)
        case 1:
            self.title = "\(dateFormatter.stringFromDate(appDelegate.selectDay!)) 月曜日"
            poikunView.backgroundColor = UIColor(red: 85/255.0, green: 142/255.0, blue: 213/255.0, alpha: 1.0)
        case 2:
            self.title = "\(dateFormatter.stringFromDate(appDelegate.selectDay!)) 火曜日"
            poikunView.backgroundColor = UIColor(red: 85/255.0, green: 142/255.0, blue: 213/255.0, alpha: 1.0)
        case 3:
            self.title = "\(dateFormatter.stringFromDate(appDelegate.selectDay!)) 水曜日"
            poikunView.backgroundColor = UIColor(red: 85/255.0, green: 142/255.0, blue: 213/255.0, alpha: 1.0)
        case 4:
            self.title = "\(dateFormatter.stringFromDate(appDelegate.selectDay!)) 木曜日"
            poikunView.backgroundColor = UIColor(red: 85/255.0, green: 142/255.0, blue: 213/255.0, alpha: 1.0)
        case 5:
            self.title = "\(dateFormatter.stringFromDate(appDelegate.selectDay!)) 金曜日"
            poikunView.backgroundColor = UIColor(red: 85/255.0, green: 142/255.0, blue: 213/255.0, alpha: 1.0)
        case 6:
            self.title = "\(dateFormatter.stringFromDate(appDelegate.selectDay!)) 土曜日"
            poikunView.backgroundColor = UIColor(red: 155/255.0, green: 187/255.0, blue: 89/255.0, alpha: 1.0)
        case 7:
             self.title = "\(dateFormatter.stringFromDate(appDelegate.selectDay!)) 今日"
             poikunView.backgroundColor = UIColor(red: 247.0/255.0, green: 150.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        default:
            
            break
        }
        
        poikunLabel.text = "\(appDelegate.poiTime.count) Poi Thank You!"
        
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
        var cap:String!
        var bottle:String!
        var label:String!
        var poipetID:String!
    }
    
    func setDay(){
        
        for var i:Int = 0 ; i < appDelegate.poiTime.count ; i++ {
            
            var poi:PoiModel
            
            //キャップがはずれているか
            if Int(appDelegate.poiCap[i]) == 1 && Int(appDelegate.poiBottle[i])==1 && Int(appDelegate.poiLabel[i])==1{
                
                switch Int(appDelegate.poipetID[i])!{
                case 1:
                    poi = PoiModel(time: "\(appDelegate.poiTime[i])", place: "\(appDelegate.poiPlace[i])" , color: UIColor(red: 217/255.0, green: 150/255.0, blue: 148/255.0, alpha: 1.0), image:UIImage(named: "petHart.png")!)//ぴんく
                case 2:
                    poi = PoiModel(time: "\(appDelegate.poiTime[i])", place: "\(appDelegate.poiPlace[i])" , color: UIColor(red: 155/255.0, green: 187/255.0, blue: 89/255.0, alpha: 1.0), image:UIImage(named: "petHart.png")!)//みどり
                default:
                    poi = PoiModel(time: "\(appDelegate.poiTime[i])", place: "\(appDelegate.poiPlace[i])" , color: UIColor(red: 247.0/255.0, green: 150.0/255.0, blue: 70.0/255.0, alpha: 1.0), image:UIImage(named: "petHart.png")!)//オレンジ
                    break
                }
                
                
            }else{
            
                
                switch Int(appDelegate.poipetID[i])!{
                case 1:
                    poi = PoiModel(time: "\(appDelegate.poiTime[i])", place: "\(appDelegate.poiPlace[i])" , color: UIColor(red: 217/255.0, green: 150/255.0, blue: 148/255.0, alpha: 1.0), image:UIImage(named: "pet.png")!)//ぴんく
                case 2:
                    poi = PoiModel(time: "\(appDelegate.poiTime[i])", place: "\(appDelegate.poiPlace[i])" , color: UIColor(red: 155/255.0, green: 187/255.0, blue: 89/255.0, alpha: 1.0), image:UIImage(named: "pet.png")!)//みどり
                default:
                    poi = PoiModel(time: "\(appDelegate.poiTime[i])", place: "\(appDelegate.poiPlace[i])" , color: UIColor(red: 247.0/255.0, green: 150.0/255.0, blue: 70.0/255.0, alpha: 1.0), image:UIImage(named: "pet.png")!)//オレンジ
                    break
                }
            }
            pois.append(poi)
        }
        
        appDelegate.poiTime = []
        appDelegate.poiPlace = []
        appDelegate.poiCap = []
        appDelegate.poiBottle = []
        appDelegate.poiLabel = []
        appDelegate.poipetID = []
        
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
    
    override func viewWillDisappear(animated: Bool) {
        //ナビゲーションバー色
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 247.0/255.0, green: 150.0/255.0, blue: 70.0/255.0, alpha: 1.0)//オレンジ
    }
    
    override func viewWillAppear(animated: Bool) {
        //ナビゲーションバー色
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 85/255.0, green: 142/255.0, blue: 213/255.0, alpha: 1.0)//あお
        
        switch appDelegate.poiWeek!{
        case 0:
            self.navigationController!.navigationBar.barTintColor = UIColor(red: 217/255.0, green: 150/255.0, blue: 148/255.0, alpha: 1.0)//ピンク
        case 6:
            self.navigationController!.navigationBar.barTintColor = UIColor(red: 155/255.0, green: 187/255.0, blue: 89/255.0, alpha: 1.0)//みどり
        case 7:
            self.navigationController!.navigationBar.barTintColor = UIColor(red: 247.0/255.0, green: 150.0/255.0, blue: 70.0/255.0, alpha: 1.0)//オレンジ
            
        default:
            
            break
        }
    }

}
