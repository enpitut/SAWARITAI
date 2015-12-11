//
//  UserSettingViewController.swift
//  PoiPet
//
//  Created by koooootake on 2015/11/13.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class UserSettingViewController: UIViewController, UITextFieldDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var RegistrationIDTextField: AkiraTextField!
    @IBOutlet weak var UserNameTextField: AkiraTextField!
    
    var registrationID: String = ""
    var userName: String = ""
    
    @IBOutlet weak var RegistrationButton: UIButton!
    //レイアウト
    var wBounds:CGFloat=0.0
    var hBounds:CGFloat=0.0
    
    let indicator:SpringIndicator = SpringIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wBounds = self.view.bounds.width
        hBounds = self.view.bounds.height*3/4
        
        RegistrationIDTextField.delegate=self
        RegistrationIDTextField.tag=0
        UserNameTextField.delegate=self
        UserNameTextField.tag=1
        
        
        RegistrationButton.enabled=false
        RegistrationButton.alpha=0.5
       
    }
    
    //UITextFieldが編集された直後に呼ばれるデリゲートメソッド.
    func textFieldDidBeginEditing(textField: UITextField){
        RegistrationButton.enabled=false
        RegistrationButton.alpha=0.5
    }
    
    //UITextFieldが編集終了する直前に呼ばれるデリゲートメソッド.
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        switch textField.tag{
        case 0:
            registrationID=textField.text!
            print("RegistrationID:\(textField.text!)")
            
        case 1:
            userName=textField.text!
            print("UserName:\(textField.text!)")
        default:
            break
        }
        
        if Int(registrationID) != nil && registrationID.characters.count == 4 && userName != ""{
            RegistrationButton.enabled=true
            RegistrationButton.alpha=1.0
        }else{
            RegistrationButton.enabled=false
            RegistrationButton.alpha=0.5
        }
        return true
    }
    
    
    //改行ボタンが押された際に呼ばれるデリゲートメソッド.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func RegistrationButton(sender: AnyObject) {
        
        print("Registration Start")
        
        let post="tmp_id=\(registrationID)&user_name=\(userName)"
        let postData=post.dataUsingEncoding(NSUTF8StringEncoding)
        let url = NSURL(string:"http://poipet.ml/signup")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod="POST"
        request.HTTPBody=postData
        
        //let config:NSURLSessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("backgroundTask")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session:NSURLSession = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        let task:NSURLSessionDataTask = session.dataTaskWithRequest(request)
        
        //ぐるぐる
        indicator.frame = CGRectMake(self.view.frame.width/2-self.view.frame.width/8, self.view.frame.height/2-self.view.frame.width/8, self.view.frame.width/4, self.view.frame.width/4)
        indicator.lineWidth = 3
        self.view.addSubview(indicator)
        indicator.startAnimation()
        
        task.resume()
    }
    
    //通信終了
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        
        let userID:String = String(data: data, encoding: NSUTF8StringEncoding)!
        
        // バックグラウンドだとUIの処理が出来ないので、メインスレッドでUIの処理を行わせる.
        dispatch_async(dispatch_get_main_queue(), {
            
            self.indicator.removeFromSuperview()
            print(userID.characters.count)
            
            //成功
            if userID.characters.count == 16 {
                print("UserID:\(userID)")
                
                let userDefault = NSUserDefaults.standardUserDefaults()
                
                userDefault.setObject("\(userID)", forKey: "ID")
                userDefault.synchronize()
                
                print("Registration Finish")
                
                let alertView = SCLAlertView()
                alertView.addButton("OK") {
                    self.appDelegate.isSetting = true
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                alertView.showCloseButton = false
                alertView.showSuccess("登録完了しました", subTitle: "登録ID : \(self.registrationID)\nユーザ名 : \(self.userName)")
                
                //失敗
            }else{
                print("Error:\(userID)")
                
                SCLAlertView().showError("登録失敗しました", subTitle: "登録ID : \(self.registrationID)\nユーザ名 : \(self.userName)")
                
            }
            
        })
        
    }
    
    @IBAction func setumeiButton(sender: AnyObject) {
        
        //はじめての画面
        self.showIntroWithCrossDissolve()
        
    }
    //説明View
    func showIntroWithCrossDissolve(){
        
        let page1 : EAIntroPage = EAIntroPage()
        let image1 = UIImageView(image: UIImage(named: "poipet_bunbetsu.png"))
        image1.contentMode = .ScaleAspectFit
        image1.frame = CGRectMake(0, 0, wBounds, wBounds)
        page1.titleIconView = image1
        page1.titleFont = UIFont.systemFontOfSize(CGFloat(18))
        page1.title = "\nPoiPetは\nゴミ捨てや分別が楽しくなる\nペットボトル専用ゴミ箱です"
        page1.desc = "　"
        page1.bgColor = UIColor(red: 230.0/255.0, green: 104.0/255.0, blue: 38.0/255.0, alpha: 1.0)//オレンジ
        
        let page2 : EAIntroPage = EAIntroPage()
        let image2 = UIImageView(image: UIImage(named: "poi3.png"))
        image2.contentMode = .ScaleAspectFit
        image2.frame = CGRectMake(0, 0, wBounds, wBounds)
        page2.titleIconView = image2
        page2.titleFont = UIFont.systemFontOfSize(CGFloat(18))
        page2.title = "まずは\nPoiPetにICカードをタッチして\n表示される4桁の数字を\nアプリに入力してください"
        page2.desc = "　"
        page2.bgColor = UIColor(red: 75.0/255.0, green: 135.0/255.0, blue: 203.0/255.0, alpha: 1.0)//オレンジ
        
        let page3 : EAIntroPage = EAIntroPage()
        let image3 = UIImageView(image: UIImage(named: "poi2.png"))
        image3.contentMode = .ScaleAspectFit
        image3.frame = CGRectMake(0, 0, wBounds, wBounds)
        page3.titleIconView = image3
        page3.titleFont = UIFont.systemFontOfSize(CGFloat(18))
        page3.title = "PoiPet for iPhoneでは\nいつどこでいくつ\nペットボトルを捨てたかを\n記録することができます"
        page3.desc = "　"
        page3.bgColor = UIColor(red: 253.0/255.0, green: 181.0/255.0, blue: 10.0/255.0, alpha: 1.0)//オレンジ
        
        let page4 : EAIntroPage = EAIntroPage()
        let image4 = UIImageView(image: UIImage(named: "poi4.png"))
        image4.contentMode = .ScaleAspectFit
        image4.frame = CGRectMake(0, 0, wBounds, wBounds)
        page4.titleIconView = image4
        
        page4.titleFont = UIFont.systemFontOfSize(CGFloat(18))
        page4.title = "\nPoiPetとアプリと連携して\nみんなで楽しく\nPoiしましょう"
        page4.desc = "　"
        page4.bgColor = UIColor(red: 230.0/255.0, green: 104.0/255.0, blue: 38.0/255.0, alpha: 1.0)//オレンジ
        
        let intro : EAIntroView = EAIntroView(frame: self.view.bounds, andPages:[page1,page3,page2,page4])
        //intro.delegate = self
        intro.showInView(self.view, animateDuration:0.0)
        
    }

    
    
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
        
    }
    
}
