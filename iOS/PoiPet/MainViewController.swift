//
//  MainViewController.swift
//  
//
//  Created by koooootake on 2015/11/02.
//
//

import UIKit

class MainViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,NSXMLParserDelegate {
    

    @IBOutlet weak var settingButton: UIBarButtonItem!
    var calendarCollectionView : UICollectionView!
    
    //現在の日時年
    var nowDay:Int = 1
    var nowMonth:Int = 1
    var nowYear:Int = 2015
    
    //今表示しているカレンダー情報
    var calendarYear:Int=2015
    var calendarMonth:Int=1
    var calendarDay:Int=1
    var nowMonthLastDay:Int=1//今月の最終日
    var lastMonthLastDay:Int=1//先月の最終日
    var nowMonthFirstWeek=1//今月の初日の曜日
    
    var swipeCount=0
    
    var monthCount:Int=0
    
    //レイアウト
    var wBounds:CGFloat=0.0
    var hBounds:CGFloat=0.0
    var hPoiBounds:CGFloat=0.0//Poiくんの高さ
    var hNavigation:CGFloat=0.0
    var hHeadBounds:CGFloat=0.0//カレンダーのヘッダーの高さ
    
    var wCell:CGFloat=0.0
    var spaceCell:CGFloat=0.0
    
    let indicator:SpringIndicator = SpringIndicator()
    let refreshControl = SpringIndicator.Refresher()
    
    //let test:UIView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        wBounds = self.view.bounds.width
        hBounds = self.view.bounds.height*3/4
        hPoiBounds = self.view.bounds.height*1/4
        
        //Navigationbar設定
        let titleImageView = UIImageView( image: UIImage(named: "logoWhite.png"))
        titleImageView.contentMode = .ScaleAspectFit
        titleImageView.frame = CGRectMake(0, 0, self.view.frame.width, self.navigationController!.navigationBar.frame.height*0.7)
        self.navigationItem.titleView = titleImageView
        //ボタン色
        self.navigationController!.navigationBar.tintColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        //背景色
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 240.0/255.0, green: 125.0/255.0, blue: 50.0/255.0, alpha: 1.0)//オレンジ
        //Navigationbar高さ保存
        hNavigation = CGFloat(self.navigationController!.navigationBar.frame.height) + CGFloat(UIApplication.sharedApplication().statusBarFrame.height)
        
        //Poiくんgif追加
        let backgroundAnimationImage=FLAnimatedImageView()
        let path = NSBundle.mainBundle().pathForResource("poikun", ofType: "gif")!
        let url = NSURL(fileURLWithPath: path)
        let animatedImage = FLAnimatedImage(animatedGIFData: NSData(contentsOfURL: url))
        backgroundAnimationImage.animatedImage = animatedImage
        //Poiくん位置
        backgroundAnimationImage.frame=CGRectMake(0.0, hBounds, wBounds, hPoiBounds)
        self.view.addSubview(backgroundAnimationImage)
        
        //カレンダー
        //現在の日付を取得する
        var now: NSDate!
        now = NSDate()
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        var comps: NSDateComponents!
        comps = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Weekday],fromDate:now)
        nowYear = comps.year
        nowMonth = comps.month
        nowDay = comps.day
        
        calendarYear = comps.year
        calendarMonth = comps.month
        calendarDay = comps.day
        
        //ぐるぐる
        indicator.frame = CGRectMake(wBounds/2-wBounds/8, hBounds/2-wBounds/8+hNavigation, wBounds/4, wBounds/4)
        indicator.lineWidth = 3
        
        refresh()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    //更新
    @IBAction func refreshButton(sender: AnyObject) {
        
        self.view.addSubview(indicator)
        self.indicator.startAnimation()
        refresh()
        
    }
    
    func refresh(){
        
        pois=[]
        
        //userID
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        if userDefault.objectForKey("ID") == nil{
            
            print("UserID:nil")
            
            //登録されていなければ登録画面を表示
            let settingViweController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingViewController")
            self.navigationController?.showDetailViewController(settingViweController!, sender: nil)
            
        }else{
            
            swipeCount=0
            
            //日付更新
            var now: NSDate!
            now = NSDate()
            let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            var comps: NSDateComponents!
            comps = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Weekday],fromDate:now)
            
            nowYear = comps.year
            nowMonth = comps.month
            nowDay = comps.day
            
            let userID:String = userDefault.objectForKey("ID") as! String
            print("UserID:\(userID)")
            print("通信開始")
            
            let url = NSURL(string: "http://poipet.ml/poilog?id=\(userID)")
            var data:NSData = NSData()
            
            do{
                
                data = try NSData(contentsOfURL: url!, options: NSDataReadingOptions())
                
            } catch {

                let alert:UIAlertController = UIAlertController(title: "Acsess False", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default) {
                    action in
                }
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            let parser : NSXMLParser! = NSXMLParser(data: data)
            
            if parser != nil{
            parser!.delegate=self
            parser!.parse()
            }else{
            print("false")
            
            let alert:UIAlertController = UIAlertController(title: "No Data", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default) {
            action in
            }
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
            }
            
            print("通信完了")
            
            if self.view.viewWithTag(100) != nil{
            
                let remove:UIView = self.view.viewWithTag(100)!
                UIView.animateWithDuration(0.1, animations: {
                    
                    remove.alpha=0.0
                    remove.removeFromSuperview()
                    self.indicator.stopAnimation(true, completion: nil)
                    
                    }, completion: { finished in

                        
                })
            }
            
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //読み込み
        
        if self.view.viewWithTag(100) == nil{
        
            calendarMonth = calendarMonth + swipeCount
            monthCount=0
            
            if calendarMonth > 12{
                calendarYear++
                calendarMonth=1
            }else if calendarMonth < 1{
                calendarYear--
                calendarMonth=12
            }
            
            print("Calendar generate")
            let calendarViews = calendarView()
            
            if swipeCount > 0{
                calendarViews.layer.position = CGPointMake(wBounds*3/2, calendarViews.frame.height/2 + hNavigation)
            }else if swipeCount < 0{
                calendarViews.layer.position = CGPointMake(-wBounds/2, calendarViews.frame.height/2 + hNavigation)
            }else{
                calendarViews.alpha=0.0
            }
            self.view.addSubview(calendarViews)
            //self.view.sendSubviewToBack(calendarViews)
            
            UIView.animateWithDuration(0.5, animations: {
                calendarViews.layer.position = CGPointMake(self.wBounds/2, calendarViews.frame.height/2 + self.hNavigation)
                calendarViews.alpha=1.0
                
            })
            
        }
    }
    
    //カレンダーView
    private func calendarView() -> UIView{
        
        nowMonthLastDay=getLastDay(calendarYear, month: calendarMonth)
        if calendarMonth == 12{
            lastMonthLastDay=getLastDay(calendarYear+1, month: 1)
        }else if calendarMonth == 1{
            lastMonthLastDay=getLastDay(calendarYear-1, month: 12)
        }else{
            lastMonthLastDay=getLastDay(calendarYear, month: calendarMonth-1)
        }
        nowMonthFirstWeek=getFirstDayWeek(calendarYear, month: calendarMonth)
        
        //セルのレイアウト
        let layout = UICollectionViewFlowLayout()
        //1つのcellのサイズ
        spaceCell=3
        //viewの縦横比に対応して配置を変更
        hHeadBounds=80.0
        if wBounds-20 < hBounds-hHeadBounds{
            layout.itemSize=CGSizeMake(((wBounds-20)-spaceCell*8)/7, ((wBounds-20)-spaceCell*8)/7)
            layout.minimumInteritemSpacing=spaceCell
            layout.minimumLineSpacing=spaceCell
            hHeadBounds=80.0
        }else{
            layout.itemSize=CGSizeMake(((wBounds-20)-spaceCell*8)/7, ((wBounds-20)-spaceCell*8)/7-spaceCell)
            layout.minimumInteritemSpacing=spaceCell
            layout.minimumLineSpacing=spaceCell
            hHeadBounds=50.0
        }
        
        wCell = layout.itemSize.width
        
        //ヘッダーのレイアウト
        layout.headerReferenceSize=CGSizeMake(wBounds, hHeadBounds)
        
        //callenderView生成
        calendarCollectionView=UICollectionView(frame: CGRectMake(10, hNavigation,(wBounds-20),hBounds-hNavigation),collectionViewLayout:layout)
        calendarCollectionView.tag = 100
        
        //カスタムセル（ペットボトル型）追加
        calendarCollectionView.registerClass(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        //ヘッダー追加
        calendarCollectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        
        calendarCollectionView.backgroundColor=UIColor.whiteColor()
        calendarCollectionView.delegate=self
        calendarCollectionView.dataSource=self
        
        return calendarCollectionView
    }
    
    //月の最終日の取得
    func getLastDay(year:Int,month:Int) -> Int{
   
        let calendar = NSCalendar.currentCalendar()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM";
        let date:NSDate = dateFormatter.dateFromString("\(year)/\(month)")!;
        let range = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date)
        let dayCount = range.length
        //print("\(year).\(month)...LastDay:\(dayCount)")
        
        return dayCount;
    }
    
    //月の初日の曜日を取得
    func getFirstDayWeek(year:Int,month:Int) ->Int{
        
        let calendar = NSCalendar.currentCalendar()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd";
        let date:NSDate = dateFormatter.dateFromString("\(year)/\(month)/01")!;
        let components: NSDateComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Weekday],fromDate:date)
        let firstDayWeek = components.weekday
        var result:Int = firstDayWeek - 2
        
        if result < 0{
            result = result + 7
        }
        
        //print("\(year).\(month)...FirstDayWeek:\(result)")
        
        return result
    }
    
    //Cellに値を設定する
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : CalendarCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CalendarCollectionViewCell
        
        let cellPath = indexPath.row-nowMonthFirstWeek

        if cellPath <= 0{
            //先月の尻
            let lastMonthDay = lastMonthLastDay + cellPath
            cell.textLabel?.text=lastMonthDay.description
            cell.iconImageView?.image=UIImage(named: "pet_back_ground_gray.png")
            
        }else if cellPath <= nowMonthLastDay{
            
            //今月
            cell.textLabel?.text = cellPath.description
            //個数カウント
            var number:Int=0
            
            for var n:Int = 0; n<pois.count; n++ {
                
                let poi = pois[n]
                if Int(poi.year) == calendarYear && Int(poi.month) == calendarMonth && Int(poi.date)==cellPath{
                    number++
                    monthCount++
                }
            }
            //数値表示
            if number != 0 {
                cell.numberLabel!.text=number.description
            }
            
            //今日
            if calendarYear==nowYear && calendarMonth==nowMonth && cellPath==nowDay {
                cell.iconImageView?.image=UIImage(named: "pet_back_ground_orange.png")
            }else{
                //曜日ごとに色分け
                if indexPath.row%7 == 0{
                    cell.iconImageView?.image=UIImage(named: "pet_back_ground_pink.png")
                }else if indexPath.row%7 == 6{
                    cell.iconImageView?.image=UIImage(named: "pet_back_ground_gleen.png")
                }else{
                    cell.iconImageView?.image=UIImage(named: "pet_back_ground_blue.png")
                }
            }
        }else{
            //来月の頭
            let nextMonthDay = cellPath-nowMonthLastDay
            cell.textLabel?.text=nextMonthDay.description
            cell.iconImageView?.image=UIImage(named: "pet_back_ground_gray.png")
        }
        
        return cell
    }
    
    //Cellのヘッダーを設定する
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let headerReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header", forIndexPath: indexPath)
        let todayLabel:UILabel = UILabel(frame: CGRectMake(20.0, 10.0,wBounds-40, hHeadBounds*3/4-10.0))
        todayLabel.text="\(calendarYear)年\(calendarMonth)月 \(monthCount) Poi"
        todayLabel.textColor=UIColor.grayColor()
        if hHeadBounds == 50{
            todayLabel.font=UIFont.systemFontOfSize(18)
        }else{
            todayLabel.font=UIFont.systemFontOfSize(24)
        }
        todayLabel.textAlignment = .Center
        headerReusableView.addSubview(todayLabel)
        
        //曜日ラベル
        for var i:Int = 0 ; i < 7 ; i++ {
            let weekLabel:UILabel = UILabel(frame: CGRectMake(10.0 - spaceCell*2 + (wCell + spaceCell) * CGFloat(i),hHeadBounds*3/4-spaceCell,wCell,hHeadBounds/4))
            //weekLabel.backgroundColor=UIColor.grayColor()
            weekLabel.layer.masksToBounds = true
            weekLabel.layer.cornerRadius = 5.0
            weekLabel.textAlignment = .Center
            if hHeadBounds == 50{
                weekLabel.font=UIFont.systemFontOfSize(8)
            }else{
                weekLabel.font=UIFont.systemFontOfSize(12)
            }
            weekLabel.textColor=UIColor(red: 85/255.0, green: 142/255.0, blue: 213/255.0, alpha: 1.0)//あお
            
            switch i{
            case 0:
                weekLabel.text="Sun"
                weekLabel.textColor=UIColor(red: 208/255.0, green: 124/255.0, blue: 122/255.0, alpha: 1.0)//ピンク
            case 1:
                weekLabel.text="Mon"
            case 2:
                weekLabel.text="Tue"
            case 3:
                weekLabel.text="Wed"
            case 4:
                weekLabel.text="Thu"
            case 5:
                weekLabel.text="Fri"
            case 6:
                weekLabel.text="Sat"
                weekLabel.textColor=UIColor(red: 155/255.0, green: 187/255.0, blue: 89/255.0, alpha: 1.0)//みどり
                
            default:
                break
            }
            headerReusableView.addSubview(weekLabel)
        }
        
        return headerReusableView
    }
    
    //Cellが選択
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if 1 > indexPath.row-nowMonthFirstWeek || indexPath.row-nowMonthFirstWeek > nowMonthLastDay{
            
        }else{
        
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd";
            let date:NSDate = dateFormatter.dateFromString("\(calendarYear)/\(calendarMonth)/\(indexPath.row-nowMonthFirstWeek)")!
            appDelegate.selectDay = date
            
            for var n:Int = 0; n<pois.count; n++ {
                
                let poi = pois[n]
                if Int(poi.year) == calendarYear && Int(poi.month) == calendarMonth && Int(poi.date)==indexPath.row-nowMonthFirstWeek{
                    //print("\(poi.time):\(poi.location)")
                    appDelegate.poiTime.append("\(poi.time)")
                    appDelegate.poiPlace.append("\(poi.location)")
                    appDelegate.poiCap.append("\(poi.cap)")
                    
                    if calendarYear==nowYear && calendarMonth==nowMonth && indexPath.row-nowMonthFirstWeek==nowDay {
                        appDelegate.poiWeek = 7
                    }else{
                        appDelegate.poiWeek = Int(indexPath.row)%7
                    }
                    

                }
            }
            
            if appDelegate.poiTime != []{
                //画面遷移
                performSegueWithIdentifier("showDay",sender: nil)
            }
        }
    }
    
    //Cellの総数を返す
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    //左スワイプで前月を表示
    @IBAction func swipePrevCalendar(sender: UISwipeGestureRecognizer) {
        //カレンダービュー消去・追加
        
        let remove:UIView = self.view.viewWithTag(100)!
        UIView.animateWithDuration(0.5, animations:{
            remove.layer.position = CGPointMake(-self.wBounds/2, remove.frame.height/2 + self.hNavigation)
        }, completion: { finished in
            remove.removeFromSuperview()
        })
        
        swipeCount = 1
    }
    
    //右スワイプで次月を表示
    @IBAction func swipeNextCalendar(sender: UISwipeGestureRecognizer) {
        
        let remove:UIView = self.view.viewWithTag(100)!
        UIView.animateWithDuration(0.5, animations:{
            remove.layer.position = CGPointMake(self.wBounds*3/2, remove.frame.height/2 + self.hNavigation)
            }, completion: { finished in
                remove.removeFromSuperview()
        })
        
        swipeCount = -1
        
    }
    
    //XML解析
    var pois : [Poi]=[Poi]()
    
    class Poi {
        var id:String!
        var date:String!
        var month:String!
        var year:String!
        var time:String!
        var location:String!
        var cap:String!
    }
    
    var currentElementName : String?
    
    let poiElementName="poi"
    let idElementName="id"
    let dateElementName="day"
    let monthEleementName="month"
    let yearEleementName="year"
    let timeEleementName="time"
    let locationEleementName="location"
    let capEleementName="cap"
    
    func parserDidStartDocument(parser: NSXMLParser) {
        print("解析開始")
    }

    func parser(parser: NSXMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName: String?,
        attributes attributeDict: [String : String])
    {
        currentElementName = nil
        if elementName == poiElementName {
            pois.append(Poi())
        } else {
            currentElementName = elementName
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        if pois.count > 0 {
            let lastPoi = pois[pois.count-1]
            if currentElementName == idElementName {
                let tmpString : String? = lastPoi.id
                lastPoi.id = (tmpString != nil) ? tmpString! + string : string
                //print("ID:\(lastPoi.id)")
            } else if currentElementName == dateElementName {
                lastPoi.date = string
                //print("DATE:\(lastPoi.date)")
            } else if currentElementName == monthEleementName{
                lastPoi.month = string
                //print("month:\(lastPoi.month)")
            } else if currentElementName == yearEleementName{
                lastPoi.year = string
                //print("month:\(lastPoi.year)")
                
            } else if currentElementName == timeEleementName{
                lastPoi.time = string
                //print("month:\(lastPoi.year)")
            } else if currentElementName == locationEleementName{
                lastPoi.location = string
                //print("month:\(lastPoi.year)")
            } else if currentElementName == capEleementName{
                lastPoi.cap = string
                //print("month:\(lastPoi.year)")
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        currentElementName = nil;
    }
    
    func parserDidEndDocument(parser: NSXMLParser)
    {
        print("解析終了")
    }
    
    
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
