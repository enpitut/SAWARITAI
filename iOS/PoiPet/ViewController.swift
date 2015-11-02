//
//  ViewController.swift
//  PoiPet
//
//  Created by koooootake on 2015/08/22.
//  Copyright (c) 2015年 koooootake. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,NSXMLParserDelegate {

    var scrollView:UIScrollView!
    var pageControl:UIPageControl!
    var navbarView:UIView!
    
    //var navTitleLabel1:UILabel!
    //var navTitleLabel2:UILabel!
    //var navTitleLabel3:UILabel!
    
    var view1:UIView!
    var view2:UIView!
    var view3:UIView!
    
    var calendarCollectionView : UICollectionView!
    
    var currentYear:Int=2015
    var currentMonth:Int=1
    var currentDay:Int=1
    var currentMonthLastDay:Int=1

    var wBounds:CGFloat=0.0
    var hBounds:CGFloat=0.0
    
    var reloadButton:UIBarButtonItem!
    
    var todayPoi:Int=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        var data:NSData? = NSData(contentsOfURL: NSURL(string: "http://210.140.67.223/poilog.php?name=kimura1&pass=kimu1")!)
        
        var parser : NSXMLParser! = NSXMLParser(data: data!)
        
        if parser != nil{
            parser!.delegate=self
            parser!.parse()
        }else{
            print("false")
        }
        
        //Creating some shorthand for these values
        wBounds = self.view.bounds.width
        hBounds = self.view.bounds.height*0.7
        
        // This houses all of the UIViews / content
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.frame = self.view.frame
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.bounces = false
        self.view.addSubview(scrollView)
        
        self.scrollView.contentSize = CGSize(width: self.view.bounds.size.width * 3, height: hBounds/2)
        
        //ナビゲーションバー
        //Putting a subview in the navigationbar to hold the titles and page dots
        navbarView = UIView()
        //navbarView.backgroundColor=UIColor(red: 247.0, green: 150.0, blue: 70.0, alpha: 1)
        self.navigationController?.navigationBar.addSubview(navbarView)
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 247.0/255.0, green: 150.0/255.0, blue: 70.0/255.0, alpha: 1)
        var titleImageView:UIImageView?=UIImageView(image: UIImage(named: "navLogoWhite.png"))
        //titleImageView?.frame=navbarView.frame
        titleImageView?.contentMode=UIViewContentMode.ScaleAspectFit
        self.navigationItem.titleView=titleImageView
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        
        reloadButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "onClickLeloadButton:")
        self.navigationItem.rightBarButtonItem=reloadButton
        
        
        //Paging control is added to a subview in the uinavigationcontroller

        pageControl = UIPageControl()
        pageControl.frame = CGRect(x: 0, y: 35, width: 0, height: 0)
        //pageControl.backgroundColor = UIColor(red: 247, green: 150, blue: 70, alpha: 1.0)
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor(red:208.0/255.0, green:124.0/255.0, blue:122.0/255.0, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        self.navbarView.addSubview(pageControl)

        
        
        //Titles for the nav controller (also added to a subview in the uinavigationcontroller)
        //Setting size for the titles. FYI changing width will break the paging fades/movement
        var titleSize = CGRect(x: 0, y: 8, width: wBounds, height: 20)
        
/*
        navTitleLabel1 = UILabel()
        navTitleLabel1.frame = titleSize
        navTitleLabel1.backgroundColor=UIColor(red: 247, green: 150, blue: 70, alpha: 1.0)
        navTitleLabel1.text = "Today"
        navTitleLabel1.textAlignment = NSTextAlignment.Center
        self.navbarView.addSubview(navTitleLabel1)
        
        navTitleLabel2 = UILabel()
        navTitleLabel2.frame = titleSize
        navTitleLabel2.text = "Calendar"
        navTitleLabel2.textAlignment = NSTextAlignment.Center
        self.navbarView.addSubview(navTitleLabel2)
        
        navTitleLabel3 = UILabel()
        navTitleLabel3.frame = titleSize
        navTitleLabel3.text = "Setting"
        navTitleLabel3.textAlignment = NSTextAlignment.Center
        self.navbarView.addSubview(navTitleLabel3)
*/

        //self.view.addSubview(navbarView)
        //navbarView.hidden=true

        //CalendarView
        view2=calendarView()
        view2.frame=CGRectMake(wBounds+10, navbarView.frame.height, wBounds-20, hBounds)
        self.scrollView.addSubview(view2)
        self.scrollView.bringSubviewToFront(view2)
        
        view1=todayView()
        view1.frame=CGRectMake(0, navbarView.frame.height, wBounds, hBounds)
        self.scrollView.addSubview(view1)
        self.scrollView.bringSubviewToFront(view1)
 
        //Setting
        view3 = settingView()
        view3.frame = CGRectMake(wBounds * 2, navbarView.frame.height, wBounds, hBounds)
        self.scrollView.addSubview(view3)
        self.scrollView.bringSubviewToFront(view3)
        
        //Poi君追加
        //self.view.addSubview(createPoiKun());
        
        let backgroundAnimationImage=FLAnimatedImageView()
        
        let path = NSBundle.mainBundle().pathForResource("poikun", ofType: "gif")!
        let url = NSURL(fileURLWithPath: path)
        let animatedImage = FLAnimatedImage(animatedGIFData: NSData(contentsOfURL: url))
        
        backgroundAnimationImage.animatedImage = animatedImage
        backgroundAnimationImage.frame=CGRectMake(0.0, hBounds, wBounds, self.view.bounds.height*0.3)
        
        self.view.insertSubview(backgroundAnimationImage, atIndex: 0)

        
       
    }
    
    internal func onClickLeloadButton(sender:UIButton){
        
        pois=[]
        
        let data:NSData? = NSData(contentsOfURL: NSURL(string: "http://210.140.67.223/poilog.php?name=kimura1&pass=kimu1")!)
        
        let parser : NSXMLParser! = NSXMLParser(data: data!)
        
        if parser != nil{
            parser!.delegate=self
            parser!.parse()
        }else{
            print("false")
        }
        
        //CalendarView
        view2=calendarView()
        view2.frame=CGRectMake(wBounds+10, 0, wBounds-20, hBounds)
        self.scrollView.addSubview(view2)
        self.scrollView.bringSubviewToFront(view2)
        
        view1=todayView()
        view1.frame=CGRectMake(0, 0, wBounds, hBounds)
        self.scrollView.addSubview(view1)
        self.scrollView.bringSubviewToFront(view1)
        
        //Setting
        view3 = settingView()
        view3.frame = CGRectMake(wBounds * 2, 0, wBounds, hBounds)
        self.scrollView.addSubview(view3)
        self.scrollView.bringSubviewToFront(view3)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        navbarView.frame = CGRect(x: 0, y: 0, width: wBounds, height: 44)
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let xOffset: CGFloat = scrollView.contentOffset.x
        
        //Setup some math to position the elements where we need them when the view is scrolled
        
        let widthOffset = wBounds / 100
        var offsetPosition = 0 - xOffset/widthOffset
        
        //Apply the positioning values created above to the frame's position based on user's scroll
/*
        navTitleLabel1.frame = CGRectMake(offsetPosition, 8, wBounds, 20)
        navTitleLabel2.frame = CGRectMake(offsetPosition + 100, 8, wBounds, 20)
        navTitleLabel3.frame = CGRectMake(offsetPosition + 200, 8, wBounds, 20)

        //Change the alpha values of the titles as they are scrolled
        
        navTitleLabel1.alpha = 1 - xOffset / wBounds
        
        if (xOffset <= wBounds) {
            navTitleLabel2.alpha = xOffset / wBounds
        } else {
            navTitleLabel2.alpha = 1 - (xOffset - wBounds) / wBounds
        }
        navTitleLabel3.alpha = (xOffset - wBounds) / wBound/
*/
        
        
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let xOffset: CGFloat = scrollView.contentOffset.x
        
        //Change the pageControl dots depending on the page / offset values
        
        if (xOffset < 1.0) {
            pageControl.currentPage = 0
        } else if (xOffset < self.view.bounds.width + 1) {
            pageControl.currentPage = 1
        } else {
            pageControl.currentPage = 2
        }
        
    }
    
    //Poi君View
    private func createPoiKun()->UIView{
        
        let poiKunView=UIView(frame: CGRectMake(0.0, hBounds, wBounds, self.view.bounds.height*0.3))
        //poiKunView.backgroundColor=UIColor.orangeColor()
        
        return poiKunView
    }
    
    //今日のんだ本数View
    private func todayView()->UIView{
        let todayView=UIView(frame: CGRectMake(0,0,wBounds,hBounds))
        
        let todayLabel:UILabel = UILabel(frame: CGRectMake(20, 0,wBounds-40, hBounds/2-10))
        todayLabel.text="- TOTAL -"
        todayLabel.textColor=UIColor.grayColor()
        todayLabel.font=UIFont.systemFontOfSize(30)
        todayLabel.textAlignment=NSTextAlignment.Center
        
        //背景
        let petImage:UIImage = UIImage(named: "pet_back_ground_pink.png")!
        let petImageView:UIImageView = UIImageView(frame:  CGRectMake(35, 55, wBounds-70, hBounds))
        petImageView.contentMode=UIViewContentMode.ScaleAspectFit
        petImageView.image=petImage
        //本数のラベル
        let todayNumberLabel:UILabel = UILabel(frame: CGRectMake(20, 80,wBounds-40, hBounds))
        todayNumberLabel.text=pois.count.description
        todayNumberLabel.textColor=UIColor.whiteColor()
        todayNumberLabel.font=UIFont.systemFontOfSize(100)
        //todayNumberLabel.font=UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
        todayNumberLabel.textAlignment=NSTextAlignment.Center
        //ぽい
        let poiLabel:UILabel = UILabel(frame: CGRectMake(90, 110,wBounds-40, hBounds))
        poiLabel.text="Poi"
        poiLabel.textColor=UIColor.whiteColor()
        poiLabel.font=UIFont.systemFontOfSize(20)
        poiLabel.font=UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
        poiLabel.textAlignment=NSTextAlignment.Center
        
        //値段
        let priceLabel:UILabel = UILabel(frame: CGRectMake(20, 160,wBounds-40, hBounds))
        let price:Int = pois.count*150
        priceLabel.text="x 150 = \(price) yen"
        priceLabel.textColor=UIColor.whiteColor()
        priceLabel.font=UIFont.systemFontOfSize(20)
        priceLabel.textAlignment=NSTextAlignment.Center
        
        todayView.addSubview(todayLabel)
        todayView.addSubview(petImageView)
        todayView.addSubview(todayNumberLabel)
        todayView.addSubview(poiLabel)
        todayView.addSubview(priceLabel)
        todayView.backgroundColor=UIColor.whiteColor()
        return todayView
    }
    
    //月にのんだ本数
    private func calendarView()->UIView{
        
        //現在の月と年と日を取得
        let dateFormatter:NSDateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy/MM/dd";
        let dateString:String = dateFormatter.stringFromDate(NSDate());
        var dates:[String] = dateString.componentsSeparatedByString("/")
        currentYear  = Int(dates[0])!
        currentMonth = Int(dates[1])!
        currentDay = Int(dates[2])!
        
        currentMonthLastDay=getLastDay(currentYear, month: currentMonth)!
        
        let layout = UICollectionViewFlowLayout()
        //せるの大きさ
        let space:CGFloat=3
        //ディスプレイサイズによって配置を変更
        if wBounds < hBounds{
            layout.itemSize=CGSizeMake(((wBounds-20)-space*8)/7, ((wBounds-20)-space*8)/7)
            layout.minimumInteritemSpacing=space
            layout.minimumLineSpacing=space
        }else{
            layout.itemSize=CGSizeMake((hBounds-space*8)/7, (hBounds-space*8)/7)
            layout.minimumInteritemSpacing=space
            layout.minimumLineSpacing=space
        }
        
        layout.headerReferenceSize=CGSizeMake((wBounds-20), hBounds*0.3)
        
        calendarCollectionView=UICollectionView(frame: CGRectMake(0, 0, (wBounds-20),hBounds),collectionViewLayout:layout)
        
        //カスタムセル追加
        calendarCollectionView.registerClass(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        //ヘッダー追加
        calendarCollectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        

        
        
        calendarCollectionView.backgroundColor=UIColor.whiteColor()
        
        calendarCollectionView.delegate=self
        calendarCollectionView.dataSource=self
        
        return calendarCollectionView
    }
    
    //その月の最終日の取得
    func getLastDay(var year:Int,var month:Int) -> Int?{
        let dateFormatter:NSDateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy/MM/dd";
        if month < 13 {
            month = 1
            year++
        }
        let targetDate:NSDate? = dateFormatter.dateFromString(String(format:"%04d/%02d/01",year,month));
        if targetDate != nil {
            //月初から一日前を計算し、月末の日付を取得
            let orgDate = NSDate(timeInterval:(24*60*60)*(-1), sinceDate: targetDate!)
            let str:String = dateFormatter.stringFromDate(orgDate)
            return 31;
        }
        return nil;
    }
    
    //初日の曜日を取得
    func setUpDays(year:Int,month:Int) ->Int{
        
        let day:Int? = currentMonthLastDay
        
        if day != nil {
            var weekday:Int = self.getWeekDay(year,month: month,day:1)
            for var i:Int = 0; i < day!;i++ {
                var week:Int = self.getWeek(year,month: month,day:i+1)
                weekday++
                if weekday > 7 {
                    weekday = 1
                }
            }
            return weekday
        }
        return 0
    }
    
    //曜日の取得
    func getWeek(year:Int,month:Int,day:Int) ->Int{
        let dateFormatter:NSDateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy/MM/dd";
        let date:NSDate? = dateFormatter.dateFromString(String(format:"%04d/%02d/%02d",year,month,day));
        if date != nil {
            let calendar:NSCalendar = NSCalendar.currentCalendar()
            let dateComp:NSDateComponents = calendar.components(NSCalendarUnit.WeekOfMonth, fromDate: date!)
            return dateComp.weekOfMonth;
        }
        return 0;
    }
    
    //第何週の取得
    func getWeekDay(year:Int,month:Int,day:Int) ->Int{
        let dateFormatter:NSDateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy/MM/dd";
        let date:NSDate? = dateFormatter.dateFromString(String(format:"%04d/%02d/%02d",year,month,day));
        if date != nil {
            let calendar:NSCalendar = NSCalendar.currentCalendar()
            let dateComp:NSDateComponents = calendar.components(NSCalendarUnit.Weekday, fromDate: date!)
            return dateComp.weekday;
        }
        return 0;
    }
    
    
    //Cellに値を設定する
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : CalendarCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CalendarCollectionViewCell
        
        //indexは0からのため
        let day = indexPath.row-self.setUpDays(currentYear, month: currentMonth)-2

        
        //
        if day <= 0{
            //先月の尻：12月
            let lastMonthDay = self.getLastDay(currentYear, month: currentMonth-1)! + day
            cell.textLabel?.text=lastMonthDay.description
            cell.iconImageView?.image=UIImage(named: "pet_back_ground_gray.png")
        }else if day <= currentMonthLastDay{
            
            //今月
            cell.textLabel?.text = day.description
            //個数カウント
            var number:Int=0
            
            for var n:Int = 0; n<pois.count; n++ {
                
                let poi = pois[n]
                if Int(poi.date)==day{
                    number++
                }
            }
            if number==0 {
                
            }else{
              cell.numberLabel!.text=number.description
            }
            
            //今日
            if day==currentDay {
                todayPoi = number
                cell.iconImageView?.image=UIImage(named: "pet_back_ground_orange.png")
            }else{
                //曜日ごとに色分け
                if indexPath.row%7 == 0{
                    cell.iconImageView?.image=UIImage(named: "pet_back_ground_pink.png")
                }else if indexPath.row%7 == 6{
                    cell.iconImageView?.image=UIImage(named: "pet_back_ground_gleen.png")
                }else{
                    cell.iconImageView?.image=UIImage(named: "pet_back_ground.png")
                }
            }
        }else{
            //来月の頭
            let nextMonthDay = day-currentMonthLastDay
            cell.textLabel?.text=nextMonthDay.description
            cell.iconImageView?.image=UIImage(named: "pet_back_ground_gray.png")
        }
        
        return cell
    }
    
    //Cellのヘッダーを設定する
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let headerReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header", forIndexPath: indexPath) 
        let todayLabel:UILabel = UILabel(frame: CGRectMake(20, 0,wBounds-40, hBounds/2-10))
        todayLabel.text="- August -"
        todayLabel.textColor=UIColor.grayColor()
        todayLabel.font=UIFont.systemFontOfSize(30)
        todayLabel.textAlignment=NSTextAlignment.Center
        /*
        var label:UILabel = UILabel(frame: CGRectMake(0, 0, wBounds, hBounds*0.1));
        label.font=UIFont.systemFontOfSize(hBounds*0.03)
        label.textAlignment=NSTextAlignment.Center
        label.text="\(currentMonth)月のペットボトル"*/
        headerReusableView.addSubview(todayLabel)
        
        return headerReusableView
    }
    
    
    //Cellが選択された際に呼び出される
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Num: \(indexPath.row)")
        //詳細画面に遷移
        /*
        pageControl.hidden=true
        navTitleLabel1.hidden=true
        navTitleLabel2.hidden=true
        navTitleLabel3.hidden=true
        */
        let appDelegate:AppDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.selectId?=indexPath.row
        let toDetailViewController:UIViewController=DetailViewController()
        self.navigationController?.pushViewController(toDetailViewController, animated: true)
    }
    

    //Cellの総数を返す
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    //今日のんだ本数View
    private func settingView()->UIView{
        let settingView=UIView(frame: CGRectMake(0,0,wBounds,hBounds))
        let settingLabel:UILabel = UILabel(frame: CGRectMake(0, 0, wBounds, hBounds))
        settingLabel.text="User"
        settingLabel.backgroundColor=UIColor.whiteColor()
        settingLabel.font=UIFont.systemFontOfSize(200)
        settingLabel.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
        settingLabel.textAlignment=NSTextAlignment.Center
        settingView.addSubview(settingLabel)
        settingView.backgroundColor=UIColor.whiteColor()
        return settingView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //XML解析
    var pois : [Poi]=[Poi]()
    
    class Poi {
        var id:String!
        var date:String!
    }
    
    var currentElementName : String?
    
    let poiElementName="poi"
    let idElementName="id"
    let dateElementName="day"
    
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
    
    func parser(parser: NSXMLParser, foundCharacters string: String?)
    {
        if pois.count > 0 {
            let lastPoi = pois[pois.count-1]
            if currentElementName == idElementName {
                let tmpString : String? = lastPoi.id
                lastPoi.id = (tmpString != nil) ? tmpString! + string! : string
                 print("ID:\(lastPoi.id)")
            } else if currentElementName == dateElementName {
                lastPoi.date = string
                print("DATE:\(lastPoi.date)")
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
    
   
    
}

